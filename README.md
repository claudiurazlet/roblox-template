# Roblox Rojo Project

Roblox game project built around Rojo, Rokit, Wally, TestEZ, generated diagnostics, task files, and Codex-ready agent guidance.

## Quick Start

For first-time project identity setup, run:

```bash
npm run init:project -- --name "My Game" --repo "your-org/my-game"
```

The initializer updates project identity, repository metadata, the Wally package name, dependencies, tools, and the generated Rojo tree.

For local project validation:

```bash
npm install
rokit install
wally install
npm run build:rojo
npm test
```

Start `rojo serve` when you are ready to sync the generated project with Roblox Studio.

## Common Commands

- `npm run build:rojo`: regenerate `default.project.json` from `src/`.
- `npm run watch:rojo`: watch `src/` and regenerate the Rojo tree.
- `npm run check:luau`: regenerate Rojo output, refresh `sourcemap.json`, and run Luau analysis.
- `npm run export:luau:diagnostics`: write changed-file diagnostics under `tasks/local/diagnostics/`.
- `npm run export:luau:diagnostics:all`: write diagnostics for all saved `src/**` files.
- `npm test`: build a disposable test place and run TestEZ through `run-in-roblox`.

## Documentation

Use [Readmes/README.md](Readmes/README.md) as the documentation map.

Most work starts with:

- [Readmes/src-architecture.md](Readmes/src-architecture.md): source layout and ownership rules.
- [Readmes/genrojotree-setup.md](Readmes/genrojotree-setup.md): Rojo generation, sourcemap, diagnostics, and troubleshooting.
- [Readmes/new-project-checklist.md](Readmes/new-project-checklist.md): project identity and first-run setup.
- [tasks/README.md](tasks/README.md): task records, backlog, archive, and task assets.

Agent-specific rules live in [AGENTS.md](AGENTS.md).

## Source Of Truth

- Runtime source lives under `src/`.
- `tools/genRojoTree.js` owns Roblox service placement.
- `default.project.json` is generated output; regenerate it instead of editing it by hand.
- Wally packages are generated under `Packages/` and `ServerPackages/`.
- `sourcemap.json`, `out/`, and `tasks/local/` are disposable local output.
