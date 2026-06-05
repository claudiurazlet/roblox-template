# Codex Guide

Use this file for agent operating rules. Durable project guidance lives in [Readmes/README.md](Readmes/README.md).

## Non-Negotiable Rules

- Repository content must be written in English: code, identifiers, comments, docs, logs, warnings, and commit messages.
- Chat replies may be in Italian when the user writes in Italian.
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

Prefer `src/UI/app`, `src/UI/core`, `src/UI/features`, `src/UI/hud`, and `src/UI/shared` for new UI work. Treat `Old` folders and `.old` files as legacy reference material.

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

- After structural changes under `src`, run `npm run build:rojo`.
- After Roblox source changes, run `npm run export:luau:diagnostics:all` when practical.
- Use `npm run check:luau` when terminal diagnostics are enough.
- Run `npm test` after testable logic changes or when test behavior may be affected.
- Add focused TestEZ coverage for deterministic behavior when practical.
- Verify both client and server entrypoints when changing networking, startup order, or replication boundaries.
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

Search `tasks/archive` only when prior task history is relevant.
