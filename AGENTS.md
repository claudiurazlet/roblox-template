# Codex Guide

Use this file for agent operating rules. Durable project guidance lives in [Readmes/README.md](Readmes/README.md).

## Non-Negotiable Rules

- Repository content must be written in English: code, identifiers, comments, docs, logs, warnings, and commit messages.
- Chat replies may be in Italian when the user writes in Italian.
- After each completed user request, include a suggested commit message in plain, user-friendly English that describes the concrete work first, using short past-tense sentences and simple verbs such as `Added`, `Changed`, `Removed`, `Fixed`, or `Updated`.
- Use the source placement summary below for routine `src/` changes. Read [Readmes/src-architecture.md](Readmes/src-architecture.md) when adding a new source area, moving existing source files, or when placement is unclear.
- Treat `default.project.json` as generated output. Regenerate it instead of editing it by hand unless the user asks for that exact file.
- Treat `tools/genRojoTree.js` as the source of truth for Roblox service placement.
- Keep server-only authority, privileged data, secrets, and trusted writes out of replicated modules and `src/UI`.
- Assume Roblox Studio-only state is unavailable unless it is represented in repo files or the user provides screenshots, exports, or logs.

## Source Snapshot

Top-level source folders use stable casing:

- `src/Startup`: client and server entrypoints.
- `src/Services`: lifecycle, networking, authority, validation, data ownership, and orchestration.
- `src/Modules`: shared pure rules, deterministic helpers, config, schemas, generators, math, validators, and transforms that can be tested without remotes.
- `src/Classes`: constructor-based stateful modules with instance lifetime, cleanup, or reusable object behavior.
- `src/UI`: React and ReactRoblox UI, replicated as a whole.
- `src/Examples`: optional local package or pattern examples.

Put new UI work under `src/UI/app`, `src/UI/core`, `src/UI/features`, `src/UI/hud`, or `src/UI/shared`.

Create a service folder when a feature owns client/server behavior, networking, player lifecycle, persistent state, validation, cooldowns, authority checks, or cross-module orchestration.

## Roblox Service Mapping

- `src/Startup/Client.client.luau` maps to `StarterPlayer/StarterPlayerScripts`.
- `src/Startup/Server.server.luau` maps to `ServerScriptService`.
- Service `Client.luau` and `Utils.luau` modules are expected to replicate through `ReplicatedStorage`.
- Service `Server.luau` modules are expected to stay in `ServerScriptService`.
- `init.luau` claims its parent folder in the generated Rojo tree; child files under that claimed folder are not mapped individually.

## Tooling

Use `package.json` as the source of truth for npm scripts. Validation below defines when required verification commands must be run. See [Readmes/genrojotree-setup.md](Readmes/genrojotree-setup.md) for Rojo and diagnostics tooling details.

## Implementation Defaults

- Do not add startup wiring for placeholder services.
- For early gameplay, prioritize performance, player feel, readable feedback, and simple fun over precision-heavy simulation or overbuilt anti-cheat.
- Use `Networker` for service-level client/server communication before adding raw remotes.
- Use `Dataservice` plus `ServicePlayerData` for standard per-player persistence. Use `ProfileService` only when lower-level profile control is required.
- Use React and ReactRoblox for new UI under `src/UI` unless explicitly requested otherwise.
- Use TestEZ and the existing runner for deterministic module tests before adding a custom test harness.
- Treat package presence in `wally.toml` as availability, not proof that the package is already wired into gameplay.
- When investigating performance, check cleanup, repeated allocations, polling, remote volume, startup work, and UI churn before broader rewrites.

## Validation

- Run final verification after every request that changes repository files, before the final reply.
- Assume `npm run watch:rojo` normally keeps the Rojo tree current when files under `src/` are touched. Start `npm run watch:rojo`, only when Rojo tree generation appears stale or broken.
- If any saved Roblox source under `src/` changed, run `npm run export:luau:diagnostics:all` after Rojo regeneration.
- Run `npm test` after every completed request that changes repository files.
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
