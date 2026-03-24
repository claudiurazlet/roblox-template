---
name: close-task
description: Review a completed task, finalize its markdown record, and decide whether .github or workflow assets need updates.
agent: github-governance
argument-hint: task file path and optional summary of what was implemented
---

# Close Task

Review the specified task file and the completed work.

## Instructions

1. Finalize the verification, review, and completion sections.
2. Decide whether any stable learning belongs in `.github/`, `Readmes/`, or task templates.
3. Update the `AI Context Updates` section with concrete actions or an explicit `none`.
4. If the task record is worth preserving, recommend whether it should remain in `tasks/active/` or move to `tasks/archive/`.