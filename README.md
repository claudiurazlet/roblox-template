# Roblox Rojo Template

This repository is a reusable Roblox game template built around Rojo, Rokit, Wally, TestEZ, task files, and GitHub Copilot customizations.

## Quick Start

Create a new repository from this template, then run:

```bash
npm run init:project -- --name "My Game" --repo "your-org/my-game"
```

That command updates the project name, repository metadata, Wally package name, installs dependencies and tools, and regenerates the Rojo project file.

After that:

1. Open the repository in VS Code.
2. Run the `Watch Rojo Tree` task.
3. Start `rojo serve` when you want to sync with Studio.
4. Use `npm test` for headless TestEZ runs.

## Core Docs

- [Readmes/new-project-checklist.md](Readmes/new-project-checklist.md)
- [Readmes/genrojotree-setup.md](Readmes/genrojotree-setup.md)
- [Readmes/networker.md](Readmes/networker.md)
- [Readmes/testez.md](Readmes/testez.md)
- [tasks/README.md](tasks/README.md)

## Template Defaults

- Rojo tree generation is driven by `tools/genRojoTree.js`.
- `default.project.json` is generated output and should not be edited manually.
- `src/Startup/Client.client.luau` and `src/Startup/Server.server.luau` are the runtime entrypoints.
- `src/Services/<ServiceName>/Client.luau`, `Server.luau`, and `Utils.luau` are the preferred service layout.

## GitHub Copilot Workflow

The repository includes reusable Copilot assets under `.github/`:

- repo-wide instructions
- path-specific instructions
- prompts for task creation, review, debug, and closeout
- custom agents for planning, coding, debugging, review, and `.github` governance

When you create a new game from this template, keep those assets unless your workflow changes substantially.