# Codex Guide

Use this file for agent operating rules. Durable project guidance lives in [Readmes/README.md](Readmes/README.md).

## Non-Negotiable Rules

- Repository content must be written in English: code, identifiers, comments, docs, logs, warnings, and commit messages.
- Chat replies may be in Italian when the user writes in Italian.
- After each completed user request, include a suggested commit message in plain, user-friendly English that describes the concrete work first, using short past-tense sentences and simple verbs such as `Added`, `Changed`, `Removed`, `Fixed`, or `Updated`.
- Work only inside the project being edited. Inspect sibling projects only when the user explicitly names them as references.
- Read [Readmes/src-architecture.md](Readmes/src-architecture.md) before adding or moving files under `src/`.
- Treat `default.project.json` as generated output. Regenerate it instead of editing it by hand unless the user asks for that exact file.
- Treat `tools/genRojoTree.js` as the source of truth for Roblox service placement.
- Keep server-only authority, privileged data, secrets, and trusted writes out of replicated modules and `src/UI`.
- Assume Roblox Studio-only state is unavailable unless it is represented in repo files or the user provides screenshots, exports, or logs.

## Source Snapshot

Top-level source folders use stable casing:

- `src/Startup`: client and server entrypoints.
- `src/Services`: lifecycle, networking, authority, validation, data ownership, and orchestration.
- `src/Modules`: shared pure rules, config, schemas, generators, math, validators, and transforms.
- `src/Classes`: constructor-based stateful modules with lifetime or cleanup.
- `src/UI`: React and ReactRoblox UI, replicated as a whole.
- `src/Examples`: optional local package or pattern examples.

Put new UI work under `src/UI/app`, `src/UI/core`, `src/UI/features`, `src/UI/hud`, or `src/UI/shared`. Treat `Old` folders and `.old` files as legacy reference material.

## Commands

Only document or run scripts that exist in `package.json`.

- Initialize a new game: `npm run init:project -- --name "<Game Name>" --repo "<owner>/<repo>"`
- Regenerate Rojo tree: `npm run build:rojo`
- Watch Rojo tree changes: `npm run watch:rojo`
- Refresh sourcemap: `npm run build:luau:sourcemap`
- Run Luau diagnostics: `npm run check:luau`
- Export changed-src diagnostics: `npm run export:luau:diagnostics`
- Export all-src diagnostics: `npm run export:luau:diagnostics:all`
- Run headless TestEZ: `npm test`

## Implementation Defaults

- Create a service when a feature owns client/server behavior, networking, player lifecycle, persistent state, validation, cooldowns, or authority checks.
- Keep deterministic rules in small modules or service helpers that can be tested without remotes.
- Use class-style modules when a feature owns state, lifetime, cleanup, or behavior.
- Do not force OOP when a plain module is clearer.
- Do not add startup wiring for placeholder services.
- For early gameplay, prioritize performance, player feel, readable feedback, and simple fun over precision-heavy simulation or overbuilt anti-cheat.

## Validation

- Run final verification after every request that changes repository files, before the final reply.
- If files under `src/` were added, removed, moved, or renamed, run `npm run build:rojo` first.
- If any saved Roblox source under `src/` changed, run `npm run export:luau:diagnostics:all` after Rojo regeneration.
- Run `npm test` after every completed request that changes repository files.
- Use `npm run check:luau` only for in-progress terminal diagnostics. Do not use it as a replacement for final diagnostics export after `src/` changes.
- When adding or changing deterministic rules, validation, cooldowns, serialization, math, generators, or pure UI helpers, add or update focused TestEZ specs before running `npm test`.
- When changing networking, startup order, or replication boundaries, inspect both `src/Startup/Client.client.luau` and `src/Startup/Server.server.luau` and confirm the changed modules are required from the correct side.
- Clearly report any verification command that could not be run.

## On-Demand Docs

- Documentation map: [Readmes/README.md](Readmes/README.md)
- Source architecture: [Readmes/src-architecture.md](Readmes/src-architecture.md)
- Rojo tooling and diagnostics: [Readmes/genrojotree-setup.md](Readmes/genrojotree-setup.md)
- New project bootstrap: [Readmes/new-project-checklist.md](Readmes/new-project-checklist.md)
- Game planning order: [Readmes/game-planning-order.md](Readmes/game-planning-order.md)
- Networker usage: [Readmes/networker.md](Readmes/networker.md)
- TestEZ usage: [Readmes/testez.md](Readmes/testez.md)
- Sift usage: [Readmes/sift.md](Readmes/sift.md)
- Visual references: [Readmes/references/README.md](Readmes/references/README.md)
- Task workflow: [tasks/README.md](tasks/README.md)

Search `tasks/archive` only when the user asks about past work, a current task references archived work, or active docs and backlog do not explain an existing convention.
