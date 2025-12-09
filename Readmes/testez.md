# Guida rapida a TestEZ

Questa guida spiega come usare TestEZ nel progetto, usando il codice già presente come esempio.

## Dipendenza e struttura
- TestEZ è installato come dev-dependency Wally (`roblox/testez@0.4.1`). Assicurati di aver eseguito `wally install`, che crea `DevPackages/_Index` con TestEZ.
- I test vivono in `ReplicatedStorage.Shared.Modules.Test.Specs` (vedi `default.project.json`).
- Il runner si trova in `Shared.Modules.Test.Runner` ed esporta `run` e `getTestEZ`.

## Scrivere uno spec
- I file di test usano estensione `.spec.luau` e ritornano una funzione che definisce `describe`/`it`.
- Esempio (`src/Modules/Test/Specs/Greeting.spec.luau`):

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

Linee guida rapide:
- `describe("nome", fn)` raggruppa test correlati.
- `it("fa qualcosa", fn)` definisce un caso di test.
- Le asserzioni si fanno con `expect(value).to.<matcher>(...)` (ad es. `to.equal`, `to.be.ok`, `to.be.near`, `to.never.throw`, `to.be.a`, ecc.).
- Importa il modulo da testare via `ReplicatedStorage.Shared.Modules...` per rispecchiare l’albero Rojo.

## Runner
`src/Modules/Test/Runner.luau` carica TestEZ da `DevPackages/_Index`, trova la cartella `Specs` e lancia i test con il reporter testuale.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getTestEZ()
	local devPackages = ReplicatedStorage:FindFirstChild("DevPackages")
	assert(devPackages, "DevPackages folder missing; run `wally install`.")

	local index = devPackages:FindFirstChild("_Index")
	assert(index, "DevPackages/_Index missing; run `wally install`.")

	for _, pkg in ipairs(index:GetChildren()) do
		local module = pkg:FindFirstChild("testez")
		if module then
			return require(module)
		end
	end

	error("Could not find TestEZ in DevPackages/_Index")
end

local function run()
	local TestEZ = getTestEZ()
	local TestBootstrap = TestEZ.TestBootstrap
	local TextReporter = TestEZ.Reporters.TextReporter

	local testsRoot = ReplicatedStorage.Shared.Modules.Test:FindFirstChild("Specs")
	assert(testsRoot, "No Specs folder under Shared.Modules.Test")

	return TestBootstrap:run({ testsRoot }, TextReporter)
end

return {
	run = run,
	getTestEZ = getTestEZ,
}
```

## Eseguire i test
- In Studio (Command Bar):

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Test = require(ReplicatedStorage.Shared.Modules.Test)
local results = Test.run()
print(results)
```

- Output: il TextReporter stampa i risultati nella console; `results` contiene il riepilogo strutturato.

## Matchers utili
- Uguaglianza: `expect(a).to.equal(b)`
- Verità: `expect(a).to.be.ok()`
- Vicinanza numerica: `expect(a).to.be.near(b, diff)`
- Tipo: `expect(a).to.be.a("string")`
- Errori: `expect(fn).to.throw()` / `expect(fn).to.never.throw()`
- Tabelle: `expect(tbl).to.contain(value)` / `expect(tbl).to.be.a("table")`

## Suggerimenti
- Metti ogni modulo testato sotto `Shared.Modules` così il runner lo può richiedere facilmente.
- Organizza gli spec per feature (es. `Player.spec.luau`, `Inventory.spec.luau`).
- Se aggiungi altre cartelle di test, includile nel runner o usa naming coerente.
- Esegui `wally install` ogni volta che aggiungi/aggiorni dipendenze Wally prima di avviare i test.
