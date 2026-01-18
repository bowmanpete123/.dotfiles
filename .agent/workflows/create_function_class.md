# Workflow: Create Function or Class

**Goal**: Implement a new coding structure (Function or Class) with TDD and high quality.

---

## Step 1: Business Analysis & Task Breakdown
**Role**: [Business Analyst](../roles/business_analyst.md)
**Input**: `task.md` + Architect Spec.
**Action**:
1.  **Analyze & Inquire (CRITICAL)**: Review the technical spec and ask the user as many clarifying questions as necessary to tease out every possible edge case, error state, and nuance. Be as **informative** as possible.
2.  **Define Scenarios**: Brainstorm exhaustive behavioral scenarios (Happy/Edge/Error).
3.  **Break Down `task.md`**: As the primary owner of `task.md` for this workflow, break down the high-level unit task into granular, testable sub-items representing individual scenarios.
4.  **Confirm**: Document detailed scenarios in the **Spec File** (naming convention: `specs/{requirement_or_ticket_number}_{identifying_string}_spec.md`) and **Get EXPRESS USER APPROVAL** before triggering the next role.

---

## Step 2: Test Engineering (TDD)
**Role**: [Test Engineer](../roles/test_engineer.md)
**Input**: `task.md` (contains target files) + Spec File.
**Action**:
1.  **Read Blueprint**: Open the **Spec File** identified in `task.md`.
2.  **Transcribe Scenarios**: Translate every scenario defined in the Spec File into a `pytest-kedge` test case in the **Target Test File**.
3.  **Update `task.md`**: Mark items as "Tests Ready" once the suite is complete.

---

## Step 3: Development
**Role**: [Developer](../roles/developer.md)
**Input**: `task.md` (contains target files) + Failing Tests.
**Action**:
1.  Read the **Target Source File** path from `task.md`.
2.  Implement code in that file.
3.  Run `mise run test` against the **Target Test File**.
**Constraint**: Code must run against the tests provided. Developer CANNOT modify the test file.

---

## Step 4: Quality Review
**Role**: [Code Reviewer](../roles/code_reviewer.md)
**Input**: Source code, Tests (paths from `task.md`), and `review_logs/`.
**Action**:
1.  Run the **full project quality suite** (`mise run check`) to verify the new feature integrates correctly, follows style guides, and causes no regressions.
2.  Document any errors or unexpected behaviors in `review_logs/`.
3.  Check for recurring mistakes (cross-reference previous logs).
4.  If FAIL: Send back to Step 2 with specific feedback (Return to Test Engineer).
5.  If PASS: Approve.

---

## Step 5: Deployment
**Role**: [Project Manager](../roles/project_manager.md)
**Input**: Approved Code.
**Action**: Create commit and PR description.
