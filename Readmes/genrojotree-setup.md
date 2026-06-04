# Rojo Tree And Diagnostics

This project keeps a compact source layout in `src/` and generates `default.project.json` with `tools/genRojoTree.js`.

## Generated Rojo Tree

- `default.project.json` is generated output. Do not edit it by hand for normal workflow changes.
- `tools/genRojoTree.js` is the source of truth for Roblox service placement.
- Run `npm run build:rojo` after structural changes.
- Run `npm run watch:rojo` or the VS Code `Watch Rojo Tree` task while iterating on source layout.

If you are starting a brand-new game from this repository, run `npm run init:project -- --name "My Game" --repo "your-org/my-game"` first so project identity is updated consistently.

## Source Layout

```text
src/
  Classes/
  Modules/
  Services/
    <ServiceName>/
      Client.luau
      Server.luau
      Utils.luau
  Startup/
    Client.client.luau
    Server.server.luau
  UI/
```

## Mapping Rules

- `src/Startup/Client.client.luau` maps to `StarterPlayer/StarterPlayerScripts`.
- `src/Startup/Server.server.luau` maps to `ServerScriptService`.
- `src/UI` maps directly to `ReplicatedStorage.UI`.
- `Client.luau`, `Utils.luau`, `Types.luau`, and shared modules map to `ReplicatedStorage.Shared`.
- `Server.luau` and filenames containing `server` map to `ServerScriptService`.
- `src/UI` and `src/Startup` are handled explicitly and are skipped by the generic recursive scan.
- `init.luau` claims its parent folder in the generated tree, so child files under that claimed folder are not mapped individually.
- Folder names are PascalCased in the generated tree.

## Tool Scripts

- `tools/genRojoTree.js`: regenerates `default.project.json` from the current `src/` tree.
- `tools/runLuauAnalyze.js`: wraps `luau-lsp analyze`, loading Roblox engine definitions from the Luau LSP cache and `testez.d.luau`.
- `tools/exportLuauDiagnostics.js`: refreshes Rojo output and the sourcemap, runs the analyzer, and writes grouped reports under `tasks/local/diagnostics/`.
- `tools/initProject.js`: bootstrap helper for creating a new project from this template.

## Diagnostics Commands

- `npm run check:luau`: regenerate Rojo, refresh `sourcemap.json`, and run `luau-lsp analyze` across `src/` and `scripts/`.
- `npm run export:luau:diagnostics`: export diagnostics for git-changed or untracked `src/**` files.
- `npm run export:luau:diagnostics:all`: export diagnostics for all `src/**` files.

The diagnostics exporter reflects saved-file static diagnostics. It does not read unsaved editor buffers or scrape the live VS Code Problems panel.

## VS Code Tasks

- `Watch Rojo Tree`: runs `npm run watch:rojo`.
- `Check Luau Diagnostics`: runs `npm run check:luau`.
- `Export Luau Diagnostics Report (Changed src)`: runs `npm run export:luau:diagnostics`.
- `Export Luau Diagnostics Report (All src)`: runs `npm run export:luau:diagnostics:all`.

## Setup

From the repo root:

```bash
npm install
rokit install
wally install
```

Then in VS Code:

1. Press `Ctrl+Shift+P`.
2. Choose "Tasks: Run Task".
3. Select `Watch Rojo Tree`, `Check Luau Diagnostics`, or one of the diagnostics export tasks.

## What To Commit

- Commit `default.project.json` after regenerating it.
- Commit source, docs, `package.json`, `package-lock.json`, and tool script changes.
- Do not commit `sourcemap.json`, `out/`, `tasks/local/`, `Packages/`, or `ServerPackages/`.

## Troubleshooting

- If `default.project.json` is stale, run `npm run build:rojo`.
- If `sourcemap.json` is stale or Luau navigation is confused, run `npm run build:luau:sourcemap` or delete `sourcemap.json` and let tooling recreate it.
- If Roblox engine definitions are missing, open VS Code, run `Luau: Download API Types`, then rerun diagnostics.
- If `luau-lsp`, `rojo`, `wally`, or `run-in-roblox` is missing, run `rokit install`.
- If packages are missing, run `wally install`.

## Credits

- Original generator idea: [leifstout/genRojoTree](https://github.com/leifstout/genRojoTree)
- YouTube tutorial reference: [Roblox TypeScript Tutorial](https://www.youtube.com/watch?v=ouNVJcGH9MA)
