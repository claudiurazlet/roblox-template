---
name: debug-task
description: Investigate a Roblox bug, replication issue, startup problem, race condition, or performance regression and narrow it to a root cause.
agent: roblox-debugger
argument-hint: task file path, repro steps, logs, bug summary, or affected files
---

# Debug Task

Investigate the specified Roblox issue and narrow it to a concrete root cause or a short list of likely causes.

## Instructions

1. Clarify the observed failure, expected behavior, and current evidence.
2. Check client, server, shared, and startup boundaries before proposing fixes.
3. Make networking, replication, and state-ownership assumptions explicit.
4. Recommend the smallest next change or validation step that would confirm the root cause.
5. Update implementation notes when a task file exists.