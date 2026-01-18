# Workflow: Implement Task

**Trigger**: New task from Jira, GitHub Issue, or direct user request.

---

## Step 0: Task Source (Choose One)

### Option A: From Jira
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  Run: `jira issue list -q "assignee = currentUser() AND sprint in openSprints()"`
2.  Ask user to select the ticket.
3.  Extract requirements from ticket description.

### Option B: From GitHub Issue
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  Run: `gh issue list --assignee @me`
2.  Ask user to select the issue.
3.  Extract requirements from issue body.

### Option C: From Roadmap / Direct
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  **Check Roadmap**: Ensure item matches an entry in `docs/roadmap/ROADMAP.md`.
2.  **Fallback**: If truly ad-hoc, document requirements in `task.md`.

---

## Step 1: Git Setup
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  Checkout base: `git checkout main && git pull origin main`
2.  Branch: `git checkout -b feature/{task-id}-{short-description}`

---

## Step 2: Decomposition
**Role**: [Architect](../roles/architect.md)
**Input**: Task requirements.
**Action**:
1.  Create a **Micro-Plan**: List of technical units to build.
    - Unit 1: Class `X`
    - Unit 2: Function `Y`
2.  Populate `task.md` with items.
3.  Get user approval on the plan.

---

## Step 3: Execution Loop (Repeat for Each Unit)
**Input**: The specific unit from the Micro-Plan & Behavioral Scenarios.
**Action**:
1.  Trigger the **[Create Function or Class](./create_function_class.md)** workflow for each individual unit identified in the Micro-Plan.
2.  Ensure each unit is fully reviewed and approved before proceeding to the next.

---

## Step 4: Final Verification
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  Verify all units from the Micro-Plan are complete.
2.  Create commit: `git add . && git commit -m "feat: {description}"`
3.  Push and create PR: `git push -u origin HEAD && gh pr create --fill`
