# TestEZ

Use this guide when adding or running tests in this template.

## Local Setup

- Dependency: `TestEZ = "roblox/testez@0.4.1"` in [../wally.toml](../wally.toml).
- Headless runner tool: `run-in-roblox` from [../rokit.toml](../rokit.toml).
- Runner module: [../src/Modules/Test/Runner.luau](../src/Modules/Test/Runner.luau).
- Existing specs: `src/Modules/Test/Specs/*.spec.luau`.
- Bootstrap script: [../scripts/run-tests.server.luau](../scripts/run-tests.server.luau).

Run `wally install` before testing if `Packages/_Index` is missing.

## Writing Specs

Use the `.spec.luau` suffix for spec files. Each spec file returns a function that defines `describe` and `it` blocks.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Greeting = require(ReplicatedStorage.Shared.Modules.Core.Greeting)

return function()
	describe("formatGreeting", function()
		it("formats the provided name", function()
			local result = Greeting.formatGreeting("Roblox")
			expect(result).to.equal("Hello, Roblox!")
		end)
	end)
end
```

Guidelines:

- Keep deterministic specs under `src/Modules/Test/Specs`.
- Require modules through the generated Rojo tree path, for example `ReplicatedStorage.Shared.Modules...`.
- Put server-only specs under `ServerScriptService.Modules.Test.Specs` only when they need server-only modules.
- Write focused tests for changed rules, validation, cooldowns, serialization, math, and pure UI helpers.

## Running Tests

Main command:

```bash
npm test
```

This builds a disposable place at `out/test-place.rbxlx`, runs [../scripts/run-tests.server.luau](../scripts/run-tests.server.luau), and fails the command when TestEZ reports failures.

In Studio Command Bar:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Test = require(ReplicatedStorage.Shared.Modules.Test.Runner)
local results = Test.run()
print(results)
```

The TextReporter prints per-spec output, and `results` contains the structured summary.

## Luau LSP Globals

TestEZ globals such as `describe`, `it`, and `expect` are injected at runtime. This repo includes [../testez.d.luau](../testez.d.luau) for static tooling.

When VS Code or Luau LSP reports unknown TestEZ globals, add this to `.vscode/settings.json`:

```json
"luau-lsp.types.definitionFiles": ["testez.d.luau"]
```

## Useful Matchers

- `expect(a).to.equal(b)`
- `expect(value).to.be.ok()`
- `expect(a).to.be.near(b, diff)`
- `expect(value).to.be.a("string")`
- `expect(fn).to.throw()`
- `expect(fn).to.never.throw()`

## Troubleshooting

- Missing packages: run `wally install`.
- Missing Rojo or run-in-roblox: run `rokit install`.
- Test place is stale: rerun `npm test`; the place is disposable output.
- Static tooling does not know TestEZ globals: confirm `testez.d.luau` is listed in Luau LSP settings.
