---
name: review-task
description: Review a completed task or diff for bugs, regressions, missing tests, and Roblox-specific risks before closeout.
agent: code-reviewer
argument-hint: task file path, diff summary, or files to review
---

# Review Task

Review the specified task, diff, or files before the task is closed.

## Instructions

1. Read the task file, diff, or changed files.
2. Prioritize concrete findings over style commentary.
3. Call out missing verification when behavior changed without enough evidence.
4. Use the debugger handoff if a suspected issue needs deeper investigation.
5. Update the task file's `Review Findings` section when a task file exists.