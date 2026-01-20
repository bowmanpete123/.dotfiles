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
1.  **Take 3rd Level Task From Roadmap**: Ensure item matches an entry in `docs/roadmap/ROADMAP.md`.
2.  **Fallback**: If truly ad-hoc, document requirements in `task.md`.

---

## Step 1: Git Setup
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  Checkout base: `git checkout main && git pull origin main`
2.  Populate `task.md` with the new "feature name" `{task-id}-{short-description}` make sure this is reference able
2.  Branch: `git checkout -b feature/{task-id}-{short-description}`

---

## Step 2: Decomposition
**Role**: [Business Analyst](../roles/business_analyst.md)
**Input**: Create Scenarios From Feature Requirement.
**Action**:
1.  Create a **Micro-Plan**: List of User Scenarios for the feature.
3.  **Analyze & Inquire (CRITICAL)**: Review the technical spec and ask the user as many clarifying questions as necessary to tease out every possible edge case, error state, and nuance. Be as **informative** as possible.
4.  **Define Scenarios**: Brainstorm exhaustive behavioral scenarios (Happy/Edge/Error).
5.  **Break Down `task.md`**: As the primary owner of `task.md` for this workflow, break down the high-level unit task into granular, testable sub-items representing individual scenarios.
5.  **Confirm**: Document detailed scenarios in the **Spec File** (naming convention: `docs/spec/{feature_name}_spec.md`) and **Get EXPRESS USER APPROVAL** before triggering the next role.

---

## Step 3: Execution Loop (Repeat for Each Behavioural Scenario)
**Input**: The specific scenario from the Micro-Plan & Behavioural Scenarios.
**Action**:
1.  Trigger the **[Create Business Logic](./create_busines_logic.md)** workflow for each individual scenario identified in the Micro-Plan.
2.  Ensure each scenario is fully reviewed and approved before proceeding to the next.

---

## Step 4: Final Verification
**Role**: [Project Manager](../roles/project_manager.md)
**Action**:
1.  Verify all units from the Micro-Plan are complete.
2.  Create commit: `git add . && git commit -m "feat: {description}"`
3.  Push and create PR: `git push -u origin HEAD && gh pr create --fill`
