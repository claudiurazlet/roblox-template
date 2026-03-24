---
name: roblox-library-expert
description: Use when choosing, evaluating, integrating, or debugging Roblox libraries in this template, especially Wally packages such as Networker, Dataservice, ServicePlayerData, React, ReactRoblox, Janitor, Promise, Sift, Charm, Ripple, or TestEZ.
user-invocable: true
---

# Roblox Library Expert

Use this skill when a task depends on selecting the right library, understanding how an existing package should be used in this template, or deciding whether a new dependency is justified.

## Primary sources

- [copilot-instructions.md](../../copilot-instructions.md)
- [roblox-project.instructions.md](../../instructions/roblox-project.instructions.md)
- [README.md](../../../Readmes/README.md)
- [networker.md](../../../Readmes/networker.md)
- [testez.md](../../../Readmes/testez.md)
- [wally.toml](../../../wally.toml)

## What this skill is for

- Decide whether a package already present in `wally.toml` fits the task.
- Compare template defaults with lower-level alternatives.
- Avoid reinventing infrastructure that the template already recommends.
- Identify integration risks before adding a new dependency.

## Template defaults worth checking first

- Networking: start with `Networker` before inventing raw remotes.
- Player data: start with `Dataservice` plus `ServicePlayerData` when the higher-level workflow fits.
- Lower-level player data fallback: use `ProfileService` only when direct control is actually needed.
- UI: start with `React` plus `ReactRoblox` under `src/UI`.
- Tests: start with `TestEZ` and the existing runner before inventing a custom harness.

## Recommended workflow

1. Check whether the needed capability is already covered by an installed package.
2. Check whether the package is already documented or demonstrated locally.
3. Verify that the package matches the correct runtime boundary: client-only, server-only, or shared.
4. Prefer the highest-level package that fits the task without hiding important control.
5. If proposing a new library, explain why current dependencies are insufficient.

## Questions to answer during use

- Is this a networking, data, UI, state, utility, or testing problem?
- Does the template already have a recommended default for it?
- Does the package need to run on the server, client, or both?
- Will this dependency simplify the code, or just add surface area?
- Would a focused local module be simpler than another external package?

## Common decisions in this template

- Prefer `Networker` for service-level client/server communication.
- Prefer `TestEZ` for deterministic module tests.
- Prefer `React` and `ReactRoblox` for UI instead of ad hoc screen logic.
- Prefer `Janitor` when object lifetime, connections, or cleanup logic start to accumulate.
- Treat package presence in `wally.toml` as availability, not proof that it is already wired into gameplay.

## When not to use this skill

- When the task is mainly about implementing gameplay logic with no dependency choice.
- When the problem is clearly a runtime bug or desync; use the debugger first.
- When the issue is mostly about Rojo tree structure rather than package choice.