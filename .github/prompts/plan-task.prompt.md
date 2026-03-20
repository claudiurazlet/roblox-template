---
name: plan-task
description: Refine a task markdown file into an implementation-ready plan.
agent: task-planner
argument-hint: task file path and any newly learned context
---

# Plan Task

Read the specified task file and update it so it is ready for implementation.

## Instructions

1. Review objective, context, constraints, and open questions.
2. Resolve missing planning details where possible from the repository context.
3. Update the planning, parallelization, implementation handoff, and verification sections.
4. Explicitly document any blockers or assumptions that still need user confirmation.
5. Add an `AI Context Updates` recommendation if the completed task is likely to require changes under `.github/`.
6. Call out template-specific risks when relevant, especially Rojo tree generation, replication boundaries, startup order, UI placement, or testing gaps.