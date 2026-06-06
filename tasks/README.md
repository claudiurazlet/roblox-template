# Tasks Workflow

This folder stores shared task records and templates used by planning, implementation, review, and closeout workflows for this Roblox and Rojo-based project.

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
6. Review whether `AGENTS.md`, durable docs, templates, or task workflow notes need updates after workflow, validation, or architecture changes.
7. Move the task to `tasks/archive/` only if it remains useful as project memory.

Typical task types in this repository include gameplay systems, Rojo tree or source layout changes, startup wiring, networking contracts, UI flows, and testing setup.

When a task depends on Roblox Studio-only configuration that is not visible in the workspace, record the required manual steps inside the task file with stable names for tags, attributes, folders, and instances so implementation and follow-up work stay aligned.

## Task File Rules

- Treat task files as working contracts between planning, implementation, review, and closeout passes.
- Keep task files operational and concise.
- Preserve important historical decisions inside the task file instead of silently replacing them.
- Put unresolved questions in `Open Questions`, not inside implementation notes.
- Put actionable implementation guidance in `Implementation Handoff`.
- Record Studio-only setup in `Manual Studio Setup` with concrete tag names, attribute names, instance names, and a short checklist.
- Use `AI Context Updates` to record whether the task should update `AGENTS.md`, durable docs, task templates, or nothing.
- Use `tasks/local/` for scratch notes that should not be committed.
- Do not store minute-by-minute status noise in tracked task files.

Section ownership:

- Planning-owned sections: `Planning Notes`, `Approved Plan`, `Parallelization`, `Implementation Handoff`.
- Implementation-owned sections: `Implementation Notes`, `Verification`, `Manual Studio Setup`, `Discovered Follow-Ups`.
- Review-owned section: `Review Findings`.
- Closeout-owned sections: `AI Context Updates`, `Workflow or Docs Impact`, `Closeout Decision`.
- Shared sections such as `Objective`, `Context`, and `Constraints` should not be silently rewritten during implementation. If reality diverges from the plan, record the change in execution-owned sections instead.

## Naming convention

- Use `YYYYMMDD-short-slug.md` for standalone tasks.
- If there is a stable external identifier, `TASK-123-short-slug.md` is also acceptable.
- Keep names short, lowercase, and easy to scan.

## Git policy

- Commit `AGENTS.md`, documentation, task templates, and task files that capture durable project decisions.
- Avoid committing noisy status churn.
- Use `tasks/local/` for personal notes, temporary decompositions, or experiments that should not enter project history.
- Store committed task screenshots under `tasks/assets/<task-slug>/` when they need to survive task archival.
- Reset imported or obsolete task records instead of keeping irrelevant history from another repository.
