---
name: Task Workflow
description: Rules for creating and updating shared task markdown files and AI handoff artifacts
applyTo: tasks/**
---

# Task workflow rules

Use these rules when creating or editing files under `tasks/`.

- Treat task files as working contracts between planning, implementation, and governance passes.
- Keep task files operational and concise.
- Preserve important historical decisions inside the task file instead of silently replacing them.
- Put unresolved questions in `Open Questions`, not inside implementation notes.
- Put actionable implementation guidance in `Implementation Handoff`.
- When Studio-only setup is required, record it in `Manual Studio Setup` with concrete tag names, attribute names, instance names, and a short checklist.
- Treat `tasks/backlog.md` as the canonical place for deferred follow-up work discovered during planning or implementation.
- Use task-local follow-up notes only as pointers or short summaries. Do not let multiple task files become separate future-work backlogs.
- Use `AI Context Updates` to record whether the task should update `.github/`, prompts, agents, skills, docs, or nothing.
- Use `tasks/local/` for scratch notes that should not be committed.
- Do not store minute-by-minute status noise in tracked task files.
- Respect section ownership inside task files:
	- planner-owned sections: `Planning Notes`, `Approved Plan`, `Parallelization`, `Implementation Handoff`
	- coder-owned sections: `Implementation Notes`, `Verification`, `Manual Studio Setup`, `Discovered Follow-Ups`
	- reviewer-owned sections: `Review Findings`
	- governance-owned sections: `AI Context Updates`, `Workflow or Docs Impact`, `Closeout Decision`
- Shared sections such as `Objective`, `Context`, and `Constraints` should not be silently rewritten during implementation. If reality diverges from the plan, record the change in execution-owned sections instead.