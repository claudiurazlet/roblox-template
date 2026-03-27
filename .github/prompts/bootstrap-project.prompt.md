---
name: bootstrap-project
description: Initialize a new repository from this Roblox template and verify the starting workflow.
agent: github-governance
argument-hint: project name, GitHub repo slug, optional Wally scope, and whether installs should run
---

# Bootstrap Project

Use this prompt when a new game repository has just been created from the template.

## Instructions

1. Run `npm run init:project -- --name "<Project Name>" --repo "<owner>/<repo>"` unless the user explicitly wants a manual setup.
2. If the Wally package scope should differ from the GitHub owner, add `--wally-scope`.
3. Confirm the script updated `package.json`, `wally.toml`, and `tools/genRojoTree.js`.
4. Verify that `default.project.json` regenerated successfully.
5. Tell the user which manual Git or GitHub steps still remain.
6. Suggest creating the first tracked task if the repository is about to start real feature work.