# Workflow: Define Project Vision

**Trigger**: Project Initialization OR Missing `docs/roadmap/ROADMAP.md`.

---

## Step 1: User Interview
- **Role**: [Product Owner](../roles/product_owner.md)
**Action**:
1.  Ask the user: "What is the core problem we are solving? Who is it for?"
2.  Ask about "Must-haves" vs "Nice-to-haves".
3.  Draft a rough list of features.

---

## Step 2: Create Roadmap
**Role**: [Product Owner](../roles/product_owner.md)
**Action**:
1.  Create `docs/roadmap/ROADMAP.md` using the standard convention:
    -   **Work In Progress**: (The immediate MVP features)
    -   **Further Requirements**: (Next release)
    -   **Scope Creep**: (Parking lot)
2.  Present the Roadmap to the user for approval.

---

## Step 3: Handoff
**Role**: [Product Owner](../roles/product_owner.md)
**Action**:
1.  Identify the first item in "Work In Progress".
2.  Trigger the **[Implement Task](./implement_task.md)** workflow for that specific item.
    -   *Note*: You hand off to the **Project Manager** to start the execution loop.
