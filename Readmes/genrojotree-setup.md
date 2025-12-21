# genRojoTree setup guide

## Introduction

`tools/genRojoTree.js` is a script that automates management of the Roblox project structure: it keeps a compact, developer-friendly layout in VS Code and generates the Rojo `default.project.json` file automatically.

## Goals

- **Compact structure**: keep the repo nicely organized in VS Code
- **Automatic placement**: files are mapped to the correct Roblox services:
  - `Client.luau` and `Utils.luau` → **ReplicatedStorage**
  - `Server.luau` → **ServerScriptService**
- **Hot reloading**: `default.project.json` is regenerated whenever `src/` changes

## Credits

- Original project: [leifstout/genRojoTree](https://github.com/leifstout/genRojoTree)
- YouTube tutorial reference: [Roblox TypeScript Tutorial](https://www.youtube.com/watch?v=ouNVJcGH9MA) (timestamp: 6:10:16)

## Project structure (in this repo)

This repository uses these top-level folders under `src/`:

```
src/
├── Classes/
├── Modules/
├── Services/
│   └── <ServiceName>/
│       ├── Client.luau
│       ├── Server.luau
│       └── Utils.luau (optional)
├── Startup/
│   ├── Client.client.luau
│   └── Server.server.luau
└── UI/
```

## Full setup

### 1) VS Code configuration

Two files are typically used under `.vscode/`.

#### `.vscode/settings.json`

```json
{
    "stylua.targetReleaseVersion": "latest",
    "workbench.editor.customLabels.patterns": {
        "**/init.lua": "${dirname} (${filename}.${extname})",
        "**/init.luau": "${dirname} (${filename}.${extname})",
        "**/Client.luau": "${dirname}${filename}.${extname}",
        "**/Server.luau": "${dirname}${filename}.${extname}",
        "**/Utils.luau": "${dirname}${filename}.${extname}",
        "**/*.json": "${filename}",
        "**/*.js": "${filename}"
    }
}
```

This makes tab names more descriptive (e.g. `TestServiceClient.luau` instead of `Client.luau`).

#### `.vscode/tasks.json`

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Watch Rojo Tree",
            "type": "shell",
            "command": "npm run watch:rojo",
            "options": {
                "shell": {
                    "executable": "cmd.exe",
                    "args": ["/d", "/c"]
                }
            },
            "isBackground": true,
            "problemMatcher": [],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

### 2) Node.js initialization

From the repo root:

```bash
npm install
```

This repo already includes `chokidar-cli` as a dev dependency in `package.json`.

### 3) NPM scripts

The key scripts are in `package.json`:

- `npm run build:rojo` → generates/updates `default.project.json`
- `npm run watch:rojo` → watches `src/**/*` and regenerates on changes

### 4) Rojo + Rokit

Install tools (if not already installed):

```bash
rokit.exe self-update
rokit install
```

### 5) Start watch mode

1. Open VS Code
2. Press `Ctrl+Shift+P`
3. Choose "Tasks: Run Task"
4. Select "Watch Rojo Tree"

From now on, changes under `src/` will update `default.project.json` automatically.

## Customization

### Project name

In `tools/genRojoTree.js`, change the `name` property:

```js
const tree = {
    name: "your-project-name",
    tree: {
        // ...
    },
}
```

### CustomPackages removal (if present)

If `genRojoTree.js` contains a `CustomPackages` section under `tree.ReplicatedStorage`, remove it if you do not need it.

## What to commit

- Commit `default.project.json` (generated output) but do not edit it manually.
- Commit `package.json` and `package-lock.json`.
- Do not commit `sourcemap.json` (it is regenerated).

If `sourcemap.json` causes issues, delete it and restart VS Code so the Luau Language Server regenerates it.

## Troubleshooting

- Task does not start: ensure `npm install` has been run.
- File not updating: ensure the `watch:rojo` task is running and `tools/genRojoTree.js` is correct.
- Sync issues: delete `sourcemap.json` and restart VS Code.

## How it works (high level)

`tools/genRojoTree.js`:

1. Recursively scans `src/`
2. Detects destinations based on filenames (server vs client)
3. Generates the appropriate structure in `default.project.json`
4. Maps `*Server.luau` files to **ServerScriptService**
5. Maps everything else to **ReplicatedStorage**
6. Applies PascalCase naming for folders