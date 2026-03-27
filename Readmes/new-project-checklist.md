# New Project Checklist

Use this checklist every time you create a new Roblox game repository from this template.

## Preferred Flow

If you create the repository from the GitHub template button, clone it locally and run:

```bash
npm run init:project -- --name "My Game" --repo "your-org/my-game"
```

This command updates the main project identity and then runs:

- `rokit install`
- `npm install`
- `wally install`
- `npm run build:rojo`

If your Wally scope should not match the GitHub owner, add `--wally-scope`.

```bash
npm run init:project -- --name "My Game" --repo "studio/my-game" --wally-scope "sharedstudio"
```

## What The Script Updates

- `package.json` package name and repository metadata
- `wally.toml` package name
- `tools/genRojoTree.js` DataModel name
- `README.md` quick-start command, when present

## Manual Checklist After Initialization

1. Confirm the new project name in `tools/genRojoTree.js` and regenerate Rojo if needed.
2. Confirm `wally.toml` uses the package scope you actually want.
3. Replace the root README with game-specific documentation once the project direction is stable.
4. Open VS Code and run the `Watch Rojo Tree` task.
5. Start `rojo serve` before connecting from Studio.
6. Run `npm test` at least once to confirm the headless test runner works on the machine.
7. If you copied the repository manually instead of using the GitHub template flow, remove or replace the old Git remote.

## First GitHub Repo Setup

Recommended minimum setup for a new game repository:

1. Enable branch protection for the default branch.
2. Keep the CI workflow enabled so Rojo generation stays validated.
3. Keep `.github/` prompts, agents, skills, and instructions unless the team decides to simplify them.
4. Use the pull request template for gameplay, networking, startup, or Rojo tree changes.

## Copilot And Task Workflow

Recommended early workflow:

1. Create the first tracked task from `tasks/templates/task.template.md`.
2. Use the `new-task` prompt to capture scope before implementation.
3. Use the `review-task` prompt before merging risky changes.
4. Use the `.github` governance pass when a task teaches a durable workflow rule.

## Troubleshooting

- If `default.project.json` is stale, run `npm run build:rojo`.
- If package folders are missing, run `wally install`.
- If Roblox CLI tools are missing, run `rokit install`.
- If Luau navigation becomes inconsistent, delete `sourcemap.json` and restart VS Code.