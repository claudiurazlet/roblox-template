# TestEZ quick guide

This guide explains how TestEZ is used in this project, using the existing code as reference.

## Dependencies and structure

- TestEZ is installed via Wally (`roblox/testez@0.4.1`). Run `wally install` to populate `Packages/_Index` with TestEZ.
- `run-in-roblox` is installed via Rokit (`rojo-rbx/run-in-roblox@0.3.0`) for headless test execution.
- Specs live under `ReplicatedStorage.Shared.Modules.Test.Specs` (see [`default.project.json`](../default.project.json)).
- The runner is in `Shared.Modules.Test.Runner` and exports `run` and `getTestEZ`.

## Writing a spec

- Spec files use the `.spec.luau` extension and return a function that defines `describe`/`it`.
- Example: [`src/Modules/Test/Specs/Greeting.spec.luau`](../src/Modules/Test/Specs/Greeting.spec.luau)

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Greeting = require(ReplicatedStorage.Shared.Modules.Core.Greeting)

return function()
	describe("formatGreeting", function()
		it("formats the provided name", function()
			local result = Greeting.formatGreeting("Roblox")
			expect(result).to.equal("Hello, Roblox!")
		end)

		it("defaults to 'world' when no name is given", function()
			local result = Greeting.formatGreeting(nil)
			expect(result).to.equal("Hello, world!")
		end)
	end)
end
```

Quick guidelines:

- `describe("name", fn)` groups related tests.
- `it("does something", fn)` defines a test case.
- Assertions use `expect(value).to.<matcher>(...)` (e.g. `to.equal`, `to.be.ok`, `to.be.near`, `to.never.throw`, `to.be.a`, etc.).
- Require modules via `ReplicatedStorage.Shared.Modules...` so your tests match the Rojo tree.

## VS Code / Luau LSP globals

TestEZ globals (`describe`, `it`, `expect`, etc.) are injected at runtime and are not known by static tooling.

This repo includes a type definition file at [`testez.d.luau`](../testez.d.luau) that declares these globals. If needed, add this to your `.vscode/settings.json`:

```json
"luau-lsp.types.definitionFiles": ["testez.d.luau"]
```

## Runner

[`src/Modules/Test/Runner.luau`](../src/Modules/Test/Runner.luau) loads TestEZ from `Packages/_Index`, finds the `Specs` folder, and runs tests with the text reporter.

## Running tests in Studio

In Studio (Command Bar):

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Test = require(ReplicatedStorage.Shared.Modules.Test)
local results = Test.run()
print(results)
```

The TextReporter prints results to the output; `results` contains a structured summary.

## Headless execution (run-in-roblox)

Prerequisites: `rokit install`, `wally install`, `npm install`, and Rojo available.

Main command:

```bash
npm test
```

This repo’s `package.json` runs:

```bash
rojo build default.project.json -o out/test-place.rbxlx && \
run-in-roblox --place out/test-place.rbxlx --script scripts/run-tests.server.luau
```

Script behavior (`scripts/run-tests.server.luau`):

- requires the test module (`Shared.Modules.Test`)
- runs `Test.run()`
- exits with an error code if there are failures (so CI can fail)

## Useful matchers

- Equality: `expect(a).to.equal(b)`
- Truthy: `expect(a).to.be.ok()`
- Numeric near: `expect(a).to.be.near(b, diff)`
- Type: `expect(a).to.be.a("string")`
- Errors: `expect(fn).to.throw()` / `expect(fn).to.never.throw()`

## Tips

- Keep tested modules under `Shared.Modules` so the runner can require them easily.
- Organize specs by feature (e.g. `Player.spec.luau`, `Inventory.spec.luau`).
- Run `wally install` whenever you add/update Wally dependencies before running tests.
