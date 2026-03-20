---
name: Roblox Rojo Context
description: Use when working on Roblox game code, Rojo tree layout, startup scripts, replication boundaries, or service and module organization in this template.
applyTo: src/**
---

# Roblox Rojo context

Use these notes when editing gameplay code, services, modules, UI, or startup files in this repository.

## Canonical sources

- Repository-wide workflow lives in `copilot-instructions.md`.
- The source of truth for Rojo tree layout is `tools/genRojoTree.js`.
- `default.project.json` is generated output and should not be hand-edited for normal workflow changes.

## Code organization

- `src/Services` contains feature services. Prefer the compact `<ServiceName>/Client.luau`, `Server.luau`, and optional `Utils.luau` pattern already used by this template.
- `src/Modules` contains shared game logic and utilities.
- `src/Classes` contains class-style Luau modules.
- `src/Startup` should stay focused on startup entrypoints rather than deep feature logic.
- `src/UI` contains React or ReactRoblox UI, hooks, screens, stories, and store code.

## Replication boundaries

- `Client.luau` and `Utils.luau` are expected to land in `ReplicatedStorage`.
- `Server.luau` and `Server.server.luau` execute on the server.
- `Client.client.luau` runs under `StarterPlayerScripts`.
- Keep server authority, privileged data, and write operations out of replicated modules unless the task explicitly changes that architecture.

## Structural rules

- If a change alters how code maps into Roblox services, update `tools/genRojoTree.js` rather than hand-editing `default.project.json`.
- `init.luau` claims its parent folder in the generated tree, so child mapping behavior changes when it is introduced or removed.
- `src/UI` and `src/Startup` are handled explicitly by the Rojo tree generator and should not be remapped casually.
- Prefer extending the current folder conventions before introducing deeper or inconsistent nesting.

## Validation guidance

- For structural changes, regenerate or watch the Rojo tree and verify expected placement.
- Prefer focused Luau or TestEZ coverage when changing shared module behavior.
- When touching networking or replication assumptions, verify both client and server entrypoints.