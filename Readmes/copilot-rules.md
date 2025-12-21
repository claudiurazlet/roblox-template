# Copilot response rules

- Prefer writing comments in ALL CAPS. It is easier to distinguish from commented-out code.
- New scripts must be `.luau` (not `.lua`).
- There is only one main client entry script: `src/Startup/Client.client.luau`, and one main server entry script: `src/Startup/Server.server.luau`.
- When adding/downloading a package, if you need to understand how it works, check whether it ships a guide in the repo and/or its GitHub page (and only then look for external examples).
- Never manually edit `default.project.json` (it is auto-generated when the structure changes).
- When creating tests, validate core logic and try to cover edge cases when feasible.

## Language rules (IMPORTANT)

- Chat replies can be in Italian.
- Any generated/modified project content must be in English:
	- source code, identifiers, comments, commit messages (if any)
	- documentation (Markdown files), READMEs, guides
	- user-facing strings, logs, warnings (unless explicitly requested otherwise)

## Before delivering changes

- Ensure the project builds/compiles; run build commands during development if needed.
- If automatic tests exist, run them and ensure they pass before closing the work; clearly state if they cannot be run.
- Summarize the build/test commands executed and the results (success/failure with essential details).
- If a verification fails, briefly explain the known reason and recommended next steps.
