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
2. Resolve missing planning details from repository context. If repository context does not answer them, record them as blockers or assumptions that need user confirmation.
3. Update the planning, parallelization, implementation handoff, and verification sections.
4. Explicitly document any blockers or assumptions that still need user confirmation.
5. Set `AI Context Updates` to concrete `.github` follow-up actions or an explicit `none`.
6. Call out template-specific risks when relevant, especially Rojo tree generation, replication boundaries, startup order, UI placement, or testing gaps.
