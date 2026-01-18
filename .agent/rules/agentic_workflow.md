---
description: Role-based agentic workflow for structured development
---

# Agentic Workflow Rules

## Workflow Process
You must follow the strict sequence defined in the **[Implement Task](../workflows/implement_task.md)** workflow. 

### Nested Workflows
- **Crucial**: Step 3 of `implement_task.md` triggers the **[Create Function or Class](../workflows/create_function_class.md)** workflow for each individual unit. You must follow both workflows accordingly until the task is complete.

### Primary Role Sequence
1. **[Project Manager](../roles/project_manager.md)**: Setup, Task Source, & Scripts.
2. **[Architect](../roles/architect.md)**: Decomposition & Technical Design.
3. **[Product Owner](../roles/product_owner.md)**: Vision & Roadmap Management (docs/roadmap/ROADMAP.md).
4. **[Business Analyst](../roles/business_analyst.md)**: Behavioral Requirements & Scenarios (Get EXPRESS USER PERMISSION).
5. **[Test Engineer](../roles/test_engineer.md)**: TDD Test Planning (pytest-kedge).
6. **[Developer](../roles/developer.md)**: Implementation (Pydantic & DOP).
7. **[Code Reviewer](../roles/code_reviewer.md)**: Quality Assurance & Merge (Full Project Test Suite).

**Do not deviate from this sequence. If you are unsure of the next step, consult the relevant role file.**

## Interaction Rules
1. Read the role file for your current task ALWAYS at the start of a turn.
2. Follow the permissions defined in the role.
3. **Planning**: All `implementation_plan.md` and `task.md` documents MUST explicitly link to the executable **[Workflows](../workflows/)** being used.
4. Track all progress in `task.md`.
5. Use `mise run <task>` for all project operations as defined in `.mise.toml`.
