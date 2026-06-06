# Rojo Tooling And Diagnostics

This guide covers generated project files, tool scripts, diagnostics, and troubleshooting. Source ownership rules live in [src-architecture.md](src-architecture.md).

## Generated Files

- `default.project.json`: generated Rojo tree. Regenerate it with `npm run build:rojo`.
- `sourcemap.json`: generated Luau LSP sourcemap. Regenerate it with `npm run build:luau:sourcemap`.
- `out/`: disposable build output used by test commands.
- `tasks/local/diagnostics/`: ignored local diagnostics exports.

Do not edit generated files by hand unless a task explicitly asks for that exact output.

## Setup

From the repo root:

```bash
npm install
rokit install
wally install
npm run build:rojo
```

When setting the game identity for this repository, run:

```bash
npm run init:project -- --name "My Game" --repo "your-org/my-game"
```

The initializer runs the setup steps by default.

## Scripts

- `tools/genRojoTree.js`: scans `src/` and writes `default.project.json`.
- `tools/runLuauAnalyze.js`: wraps `luau-lsp analyze` with Roblox engine definitions and `testez.d.luau`.
- `tools/exportLuauDiagnostics.js`: refreshes generated output, runs analysis, and writes Markdown plus JSON diagnostics.
- `tools/initProject.js`: updates project identity when bootstrapping a new repository.

## Commands

- `npm run build:rojo`: regenerate the Rojo project tree.
- `npm run watch:rojo`: watch `src/**` and regenerate the tree after changes.
- `npm run build:luau:sourcemap`: regenerate `sourcemap.json`.
- `npm run check:luau`: regenerate Rojo output, refresh sourcemap, and analyze `src/` plus `scripts/`.
- `npm run export:luau:diagnostics:all`: export diagnostics for every saved `src/**` file.

Matching VS Code tasks exist for Rojo watch, Luau diagnostics, and all-source diagnostics export.

## Mapping Summary

`tools/genRojoTree.js` is the source of truth for placement. The high-level rules are:

- `src/Startup/Client.client.luau` -> `StarterPlayer/StarterPlayerScripts/Client`
- `src/Startup/Server.server.luau` -> `ServerScriptService/Server`
- `src/UI` -> `ReplicatedStorage.UI`
- shared modules -> `ReplicatedStorage.Shared`
- server files -> `ServerScriptService`

See [src-architecture.md](src-architecture.md) before changing source layout or adding new top-level folders.

## Diagnostics Notes

Diagnostics reflect saved files only. They do not read unsaved editor buffers and do not scrape the live VS Code Problems panel.

Use `npm run check:luau` for quick in-progress terminal diagnostics. After saved `src/**` changes, use `npm run export:luau:diagnostics:all` for final verification so diagnostics artifacts under `tasks/local/diagnostics/` are refreshed.

If a specific Roblox API definitions file is needed, set `LUAU_LSP_ROBLOX_DEFS_PATH` before running diagnostics.

## What To Commit

Commit:

- `default.project.json` after regenerating it.
- source, docs, task files, package metadata, and tool script changes.

Do not commit:

- `sourcemap.json`
- `out/`
- `tasks/local/`
- `Packages/`
- `ServerPackages/`

## Troubleshooting

- Stale Rojo tree: run `npm run build:rojo`.
- Missing packages: run `wally install`.
- Missing CLI tools: run `rokit install`.
- Missing Roblox engine definitions: in VS Code, run `Luau: Download API Types`, then rerun diagnostics.
- Confusing Luau navigation: regenerate `sourcemap.json` or delete it and let tooling recreate it.
- Failing headless tests before execution starts: confirm `rojo`, `run-in-roblox`, packages, and `out/` creation are available.

## Credits

- Original generator idea: [leifstout/genRojoTree](https://github.com/leifstout/genRojoTree)
