---
name: roblox-template-knowledge
description: Use when working on Roblox game structure, Rojo tree generation, Luau service layout, startup entrypoints, UI placement, or task planning that depends on this template's conventions.
user-invocable: true
---

# Roblox Template Knowledge

Use this skill when the task depends on understanding how this Roblox template is organized and how source files map into the generated Rojo tree.

## Primary sources

- [copilot-instructions.md](../../copilot-instructions.md)
- [roblox-project.instructions.md](../../instructions/roblox-project.instructions.md)
- [genrojotree-setup.md](../../../Readmes/genrojotree-setup.md)
- [README.md](../../../Readmes/README.md)
- [networker.md](../../../Readmes/networker.md)
- [testez.md](../../../Readmes/testez.md)
- [genRojoTree.js](../../../tools/genRojoTree.js)

## Core concepts

- `tools/genRojoTree.js` is the source of truth for project-to-Roblox service mapping.
- `default.project.json` is generated output.
- `src/Startup/Client.client.luau` and `src/Startup/Server.server.luau` are the main entrypoints.
- Compact service folders under `src/Services` are the preferred way to group shared, client, and server logic.
- UI lives under `src/UI` and should stay aligned with the current React or ReactRoblox structure.

## How to reason about the repository

1. Check whether the change affects Rojo structure, runtime behavior, or both.
2. Keep shared modules safe to replicate and keep privileged logic server-side.
3. Prefer updating the generator and source layout over editing generated artifacts.
4. Use local docs before inventing conventions that the template may already define.

## When planning or reviewing work

- Check whether the task changes only gameplay code, only tooling, or also project structure.
- If the task teaches a stable rule, consider whether it belongs in `.github/instructions/` or in `Readmes/`.
- Prefer updating a focused instruction or doc over expanding repo-wide instructions.