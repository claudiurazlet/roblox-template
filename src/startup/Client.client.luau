--[[
	RewireTestClient.client.luau
	Test del hot reloading lato client (controllato da RewireTestConfig)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewireConfig = require(ReplicatedStorage.Shared.Modules.Core.RewireConfig)
local RewireTestConfig = require(ReplicatedStorage.Shared.Modules.Test.Rewire.RewireTestConfig)
-- local Rewire = require(ReplicatedStorage.DevPackages.Rewire)
-- local Modules = ReplicatedStorage:WaitForChild("Modules")

-- Attendi che i moduli siano disponibili
-- local RewireConfig = require(Modules:WaitForChild("Core"):WaitForChild("RewireConfig.mod.sh"))
-- local TestConfig = require(Modules:WaitForChild("Tests"):WaitForChild("Rewire"):WaitForChild("RewireTestConfig.mod.sh"))

RewireConfig.init()

-- Controlla se i test sono abilitati
if not RewireTestConfig.ENABLE_TESTS then
	print("🔕 [CLIENT] Rewire tests DISABLED - modify RewireTestConfig.ENABLE_TESTS to enable")
	return
end

print("🧪 [CLIENT] Rewire tests ENABLED")

-- Test iniziale
wait(1) -- Attendi che tutti i moduli siano caricati
-- print("=== CLIENT REWIRE TEST START ===")

local module = RewireConfig.getModuleByName("ExampleCore")
if module then
	print("🔥 [CLIENT] Modulo caricato:", module.getMessage())
end

-- Test periodico dal client - ogni chiamata ottiene la versione più recente
spawn(function()
	while wait(RewireTestConfig.CLIENT_TEST_INTERVAL) do
		local currentModule = RewireConfig.getModuleByName("ExampleCore")
		if currentModule then
			-- print("📱 [CLIENT " .. os.date("%X") .. "] Messaggio:", currentModule.getMessage())
			print("🧮 [CLIENT] Calcolo 10+7:", currentModule.calculate(10, 7))
		end
	end
end)

print(
	"💡 [CLIENT] Modifica 'ExampleCore.getMessage()' e vedrai i cambiamenti ogni "
		.. RewireTestConfig.CLIENT_TEST_INTERVAL
		.. " secondi!"
)
