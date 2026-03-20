---
name: new-task
description: Create a new task file from the repository task template and capture the initial context.
agent: task-planner
argument-hint: task title, business need, known constraints, and any related issue or file paths
---

# New Task

Create a new task markdown file under `tasks/active/` using `tasks/templates/task.template.md`.

## Instructions

1. Derive a short slug from the task title.
2. Use the file naming convention from `tasks/README.md`.
3. Fill in the metadata, objective, context, constraints, and open questions with the information provided.
4. If relevant, capture Roblox-specific scope such as affected services, startup scripts, UI screens, networking contracts, TestEZ coverage, or Rojo tree changes.
4. Leave implementation sections empty if there is not enough validated information yet.
5. If the request already contains enough detail, add an initial planning draft.

The goal is to produce a task file that can be refined by the planning agent and consumed by the implementation agent.