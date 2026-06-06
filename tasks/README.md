# Tasks Workflow

This folder stores shared task records and templates used by planning, implementation, and `.github` governance workflows for this Roblox and Rojo-based project.

## Structure

- `tasks/backlog.md`: canonical queue for deferred and future follow-up work discovered across tasks.
- `tasks/templates/`: versioned task templates and reusable markdown structures.
- `tasks/active/`: active shared task files that are worth keeping in the repository while work is in progress.
- `tasks/archive/`: completed task files preserved for project memory and later reference.
- `tasks/assets/`: committed task-specific screenshots and lightweight visual context.
- `tasks/local/`: local scratch notes and temporary handoff files. This folder is ignored by git.

## Lifecycle

1. Create a task file in `tasks/active/` from [tasks/templates/task.template.md](templates/task.template.md).
2. Refine it with the planning workflow.
3. Implement the task while keeping the handoff, verification, and any required Studio setup notes current.
4. Review the result for changes that touch networking, replication, startup order, performance, cross-module contracts, or user-facing flows.
5. Add any deferred or future work discovered during execution to [tasks/backlog.md](backlog.md).
6. Run the `.github` governance review after workflow, validation, architecture, prompts, agents, skills, templates, or durable docs change.
7. Move the task to `tasks/archive/` only if it remains useful as project memory.

Typical task types in this repository include gameplay systems, Rojo tree or source layout changes, startup wiring, networking contracts, UI flows, and testing setup.

When a task depends on Roblox Studio-only configuration that is not visible in the workspace, record the required manual steps inside the task file with stable names for tags, attributes, folders, and instances so implementation and follow-up work stay aligned.

## Naming convention

- Use `YYYYMMDD-short-slug.md` for standalone tasks.
- If there is a stable external identifier, `TASK-123-short-slug.md` is also acceptable.
- Keep names short, lowercase, and easy to scan.

## Git policy

- Commit templates, instructions, prompts, agents, skills, and task files that capture durable project decisions.
- Avoid committing noisy status churn.
- Use `tasks/local/` for personal notes, temporary decompositions, or experiments that should not enter project history.
- Store committed task screenshots under `tasks/assets/<task-slug>/` when they need to survive task archival.
- Reset imported or obsolete task records instead of keeping irrelevant history from another repository.
