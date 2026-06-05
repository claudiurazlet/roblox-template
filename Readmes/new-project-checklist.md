# New Project Bootstrap Checklist

Use this checklist when creating a new Roblox game repository from this template.

## Initialize

After creating or cloning the new repository, run:

```bash
npm run init:project -- --name "My Game" --repo "your-org/my-game"
```

Use `--wally-scope` only when the Wally package scope should differ from the GitHub owner:

```bash
npm run init:project -- --name "My Game" --repo "studio/my-game" --wally-scope "sharedstudio"
```

The initializer updates project identity and runs `rokit install`, `npm install`, `wally install`, and `npm run build:rojo` unless `--skip-install` is provided.

## What It Updates

- `package.json` name, description, repository, bugs, and homepage metadata.
- `wally.toml` package name.
- `tools/genRojoTree.js` DataModel name.
- `README.md` quick-start example when present.

## After Initialization

1. Confirm the project name in `tools/genRojoTree.js`.
2. Confirm `wally.toml` uses the intended package scope.
3. Run `npm test` once on the machine.
4. Open VS Code and run the `Watch Rojo Tree` task while editing source structure.
5. Start `rojo serve` before connecting Roblox Studio.
6. Replace the root README with game-specific documentation once the game direction is stable.
7. If the repository was copied manually, replace the old Git remote.

## GitHub Setup

Recommended minimum setup:

1. Keep the validation workflow enabled.
2. Enable branch protection for the default branch.
3. Keep the pull request template for gameplay, networking, startup, Rojo tree, or performance changes.
4. Keep `.github/` prompts, agents, skills, and instructions unless the team intentionally simplifies the workflow.

## First Project Task

Create the first tracked task from [../tasks/templates/task.template.md](../tasks/templates/task.template.md), then use [../tasks/README.md](../tasks/README.md) for the task lifecycle.

Record any Roblox Studio-only setup in the task file with stable names for instances, tags, attributes, folders, and manual configuration.

## Troubleshooting

- Stale Rojo tree: run `npm run build:rojo`.
- Missing packages: run `wally install`.
- Missing Roblox CLI tools: run `rokit install`.
- Confusing Luau navigation: regenerate `sourcemap.json` or restart VS Code.
