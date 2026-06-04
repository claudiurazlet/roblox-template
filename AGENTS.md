# Codex Guide

## Non-Negotiable Rules

- Repository content must be written in English: code, identifiers, comments, docs, logs, warnings, and commit messages.
- Chat replies may be in Italian when the user writes in Italian.
- Work only inside the project being edited. Do not inspect sibling projects unless the user explicitly names them as references.
- For source structure decisions, read [Readmes/src-architecture.md](Readmes/src-architecture.md) before adding new files under `src`.
- Treat `default.project.json` as generated output. Do not edit it by hand unless the user explicitly asks for that exact file.
- Treat `tools/genRojoTree.js` as the source of truth for Rojo service mapping.
- Preserve the top-level source casing used by this template: `src/Classes`, `src/Modules`, `src/Services`, `src/Startup`, and `src/UI`.
- Keep server-only authority, privileged data, and write operations out of replicated modules.
- Assume Roblox Studio-only state is unavailable unless it is represented in repo files or the user provides screenshots, exports, or logs.

## Project Layout

- `src/Startup/Client.client.luau`: main client startup entrypoint.
- `src/Startup/Server.server.luau`: main server startup entrypoint.
- `src/Services/<ServiceName>/Client.luau`: replicated client coordinator for a service.
- `src/Services/<ServiceName>/Server.luau`: server coordinator and server-owned behavior.
- `src/Services/<ServiceName>/Utils.luau`: shared service contracts and helpers that are safe to replicate.
- `src/Services/<ServiceName>/Types.luau`: optional shared exported types for a service.
- `src/Modules`: shared rules, config, schemas, generators, math, validators, and transforms.
- `src/Classes`: class-style modules and reusable stateful objects.
- `src/UI`: React and ReactRoblox UI code. New UI should prefer `app`, `core`, `features`, `hud`, and `shared`.
- `tasks/local`: ignored scratch logs and generated diagnostic reports.

## Rojo Mapping Notes

- `src/Startup/Client.client.luau` maps to `StarterPlayer/StarterPlayerScripts`.
- `src/Startup/Server.server.luau` maps to `ServerScriptService`.
- `src/UI` maps directly to `ReplicatedStorage.UI`.
- `Client.luau`, `Utils.luau`, `Types.luau`, and shared modules map to `ReplicatedStorage.Shared`.
- `Server.luau` and filenames containing `server` map to `ServerScriptService`.
- `src/UI` and `src/Startup` are handled explicitly by `tools/genRojoTree.js`.
- `init.luau` claims its parent folder in the generated tree; use it only when the folder should behave as one public module.
- Run `npm run build:rojo` after structural changes when the watch task may not be running or mapping needs explicit verification.

## Commands

- Initialize a new game from the template: `npm run init:project -- --name "<Game Name>" --repo "<owner>/<repo>"`
- Regenerate the Rojo tree: `npm run build:rojo`
- Watch Rojo tree changes: `npm run watch:rojo`
- Refresh sourcemap: `npm run build:luau:sourcemap`
- Run Luau diagnostics: `npm run check:luau`
- Export changed-src diagnostics: `npm run export:luau:diagnostics`
- Export all-src diagnostics: `npm run export:luau:diagnostics:all`
- Run headless TestEZ: `npm test`

Only document or use scripts that exist in this template's `package.json`. Do not copy project-specific scripts from downstream games unless they are added to the template deliberately.

## Static Analysis Tools

- `tools/runLuauAnalyze.js` wraps `luau-lsp analyze`.
- It loads Roblox engine definitions from the Luau LSP cache and `testez.d.luau`.
- Set `LUAU_LSP_ROBLOX_DEFS_PATH` to a specific definitions file when the automatic cache lookup is not enough.
- If Roblox engine definitions are missing, open VS Code, run `Luau: Download API Types`, then rerun diagnostics.
- If `luau-lsp` is missing, run `rokit install`; `luau-lsp` is managed in `rokit.toml`.
- `tools/exportLuauDiagnostics.js` refreshes Rojo output and `sourcemap.json`, runs the analyzer with GNU output, and writes Markdown plus JSON reports under `tasks/local/diagnostics/`.
- `npm run export:luau:diagnostics` checks git-changed or untracked `src/**` files.
- `npm run export:luau:diagnostics:all` checks all saved files under `src/**`.
- Diagnostics exports reflect saved-file static diagnostics. They do not scrape the live VS Code Problems panel and do not include unsaved editor buffers.

## Implementation Priorities

- Prefer modular folders over large catch-all files. If a gameplay or UI feature has its own state, networking, lifecycle, or reusable surface, create a dedicated folder for it.
- Favor reusable feature boundaries when practical, especially for UI patterns, item rolling, inventory flows, player data services, settings, tutorials, quests, loot, levels, and monetization.
- Use class-style modules when a feature owns state, lifetime, cleanup, or behavior.
- Use small pure modules for rules, config, validation, math, schemas, and transforms.
- Do not force OOP when a plain module is clearer.
- For early gameplay implementations, prioritize performance, player feel, readable feedback, and simple fun over precision-heavy simulation or overbuilt anti-cheat.
- Custom solutions are acceptable for hard-to-isolate bugs when they solve the real user-facing problem cleanly.

## Creating New Folders

Create a new folder when any of these are true:

- The feature has both client and server behavior.
- The feature owns persistent state, networking, player lifecycle, cooldowns, validation, or authority checks.
- The feature has multiple UI parts, state modules, hooks, or screens.
- The code is likely to be reused in another Roblox game template.
- The file would otherwise become a mixed bag of unrelated helpers.

Do not create a new folder just to hide one tiny helper. Put small single-purpose utilities in the closest existing module area, then extract a folder when the feature grows.

## Legacy And Reference Code

- Folders or files containing `Old` or `.old` are legacy reference material, not the preferred architecture.
- Do not add new code to `*Old` folders.
- Do not import from old folders in new code.
- When porting from an old structure, copy the useful idea into the current `src` layout and leave the old file as reference unless the user asks for cleanup.

## Validation

- If a new service must run at startup, add an explicit require/init call in the appropriate `src/Startup` file.
- After structural changes under `src`, run `npm run build:rojo` and inspect the generated placement if mapping matters.
- After Roblox source changes, run `npm run export:luau:diagnostics:all` before considering development complete.
- Use `npm run check:luau` when terminal diagnostics are enough or when validating the full `src/` plus `scripts/` analyzer pass.
- Add focused TestEZ coverage when deterministic module behavior changes and a test is practical.
- Verify both client and server entrypoints when changing networking, service initialization, or replication boundaries.

## On-Demand Docs

- Source architecture and modular folder rules: `Readmes/src-architecture.md`
- Rojo tree, tool scripts, diagnostics, and troubleshooting: `Readmes/genrojotree-setup.md`
- New project bootstrap checklist: `Readmes/new-project-checklist.md`
- Game planning order for new projects: `Readmes/game-planning-order.md`
- TestEZ runner and spec patterns: `Readmes/testez.md`
- Networker usage: `Readmes/networker.md`
- Sift usage: `Readmes/sift.md`
- Durable visual references: `Readmes/references/README.md`
- Search `tasks/archive` only when prior task history is relevant.
