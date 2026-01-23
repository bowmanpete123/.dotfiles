# setup_agent.sh
# Automates the installation of the Agentic Workflow into a target project.
# Usage: ./setup_agent.sh <target_dir> [--tracker <jira|roadmap>]

TARGET_DIR="${1:-.}"
TRACKER="roadmap"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --tracker) TRACKER="$2"; shift ;;
        *) TARGET_DIR="$1" ;;
    esac
    shift
done

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Installing Agentic Workflow into: $TARGET_DIR (Tracker: $TRACKER)"

# 1. Create Directories (All under .agent to keep root clean)
mkdir -p "$TARGET_DIR/.agent/roles"
mkdir -p "$TARGET_DIR/.agent/rules"
mkdir -p "$TARGET_DIR/.agent/workflows"

# 2. Copy Roles, Workflows, and Rules
echo "Copying roles, workflows, and rules..."
cp .agent/roles/*.md "$TARGET_DIR/.agent/roles/"
cp .agent/workflows/*.md "$TARGET_DIR/.agent/workflows/"
cp .agent/rules/*.md "$TARGET_DIR/.agent/rules/"

# 3. Configure Project Manager based on Tracker
PM_FILE="$TARGET_DIR/.agent/roles/project_manager.md"
if [ "$TRACKER" == "jira" ]; then
    echo "Configuring Project Manager for Jira..."
    sed -i '' 's/{TRACKER_INSTRUCTIONS}/- Run: `jira issue list -q "assignee = currentUser() AND sprint in openSprints()"`/' "$PM_FILE"
else
    echo "Configuring Project Manager for Roadmap..."
    sed -i '' 's/{TRACKER_INSTRUCTIONS}/- **Check Roadmap**: Check if `docs\/roadmap\/ROADMAP.md` exists.\n    - If **MISSING**: Trigger the **[Define Project Vision](..\/workflows\/define_project_vision.md)** workflow (Role: [Product Owner](..\/roles\/product_owner.md)).\n    - If **EXISTS**: Pick the next item from `Work In Progress`./' "$PM_FILE"
fi

# 3.5 Initialize mise tasks
if [ ! -f "$TARGET_DIR/.mise.toml" ]; then
    echo "Initializing .mise.toml with default tasks..."
    cat <<EOF > "$TARGET_DIR/.mise.toml"
[tools]
python = "3.12"
uv = "latest"

[tasks]
test = { run = "pytest", description = "Run unit tests" }
lint = { run = "ruff check .", description = "Run static analysis" }
format = { run = "ruff format .", description = "Format code" }
run = { run = "python src/main.py", description = "Run entry point" }
check = { depends = ["lint", "test"], description = "Run all quality checks" }
EOF
fi

# 4. Create .agent/rules/agentic_workflow.md
echo "Creating Agentic Workflow Rules..."
cat <<EOF > "$TARGET_DIR/.agent/rules/agentic_workflow.md"
---
description: Role-based agentic workflow for structured development
---

# Agentic Workflow Rules

## Workflow Process
You must follow the strict sequence defined in the [Implement Task](../workflows/implement_task.md) workflow:

1. **[Project Manager](../roles/project_manager.md)**: Setup, Task Source, & Scripts.
2. **[Architect](../roles/architect.md)**: Decomposition & Technical Design.
3. **[Product Owner](../roles/product_owner.md)**: Vision & Roadmap Management.
4. **[Business Analyst](../roles/business_analyst.md)**: Behavioral Requirements & Scenarios.
5. **[Test Engineer](../roles/test_engineer.md)**: TDD Test Planning (pytest-kedge).
6. **[Developer](../roles/developer.md)**: Implementation.
7. **[Code Reviewer](../roles/code_reviewer.md)**: Quality Assurance & Merge.

**Do not deviate from this sequence.**

## Workflow
1. Read the role file for your current task.
2. Follow the permissions defined in the role.
3. Track all progress in \`task.md\`.
EOF

# 6. Initialize task.md if not exists
if [ ! -f "$TARGET_DIR/task.md" ]; then
    touch "$TARGET_DIR/task.md"
    echo "Created empty task.md"
else
    echo "task.md already exists, skipping."
fi

# 7. Initialize ROADMAP.md if tracker is roadmap
if [ "$TRACKER" == "roadmap" ]; then
    mkdir -p "$TARGET_DIR/docs/roadmap"
    if [ ! -f "$TARGET_DIR/docs/roadmap/ROADMAP.md" ]; then
        cat <<EOF > "$TARGET_DIR/docs/roadmap/ROADMAP.md"
# Project Roadmap

## Work In Progress

- **Initial Setup**: Complete agentic workflow integration.

## Further Requirements

- **Feature Exploration**: Define next major milestones.

## Scope Creep

- **Future Ideas**: Documentation for long-term vision.
EOF
        echo "Created initial docs/roadmap/ROADMAP.md"
    else
        echo "docs/roadmap/ROADMAP.md already exists, skipping."
    fi

    # 8. Copy roadmapinfo.md if it exists
    if [ -f "roadmap/roadmapinfo.md" ]; then
        cp roadmap/roadmapinfo.md "$TARGET_DIR/docs/roadmap/"
        echo "Copied roadmap/roadmapinfo.md to docs/roadmap/"
    fi
fi

echo "✅ Setup Complete!"
echo "You can now strictly follow the agentic workflow in $TARGET_DIR"
