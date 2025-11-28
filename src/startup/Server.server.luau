local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Rewire = require(ReplicatedStorage.DevPackages.Rewire)
local TestServiceServer = require(ServerScriptService.Services.TestService.TestServiceServer)
local RewireConfig = require(ReplicatedStorage.Shared.Modules.Core.RewireConfig)
local RewireTestConfig = require(ReplicatedStorage.Shared.Modules.Test.Rewire.RewireTestConfig)

TestServiceServer:init()
RewireConfig.init()


--[[
	RewireTestServer.server.luau
	Test del hot reloading lato server (controllato da RewireTestConfig)
]]

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Modules = ReplicatedStorage:WaitForChild("Modules")
-- Attendi che i moduli siano disponibili
-- local RewireConfig = require(Modules:WaitForChild("Core"):WaitForChild("RewireConfig.luau"))
-- local TestConfig = require(Modules:WaitForChild("Test"):WaitForChild("Rewire"):WaitForChild("RewireTestConfig.luau"))

-- Controlla se i test sono abilitati
if not RewireTestConfig.ENABLE_TESTS then
	print("🔕 [SERVER] Rewire tests DISABLED - modify RewireTestConfig.ENABLE_TESTS to enable")
	return
end

print("🧪 [SERVER] Rewire tests ENABLED")

-- Test iniziale
wait(1) -- Attendi che tutti i moduli siano caricati
-- print("=== SERVER REWIRE TEST START ===")

local module = RewireConfig.getModuleByName("ExampleCore")
if module then
	print("🔥 [SERVER] Modulo caricato:", module.getMessage())
end

-- Test periodico - ogni volta che richiediamo il modulo otteniamo la versione più recente
spawn(function()
	while wait(RewireTestConfig.SERVER_TEST_INTERVAL) do
		local currentModule = RewireConfig.getModuleByName("ExampleCore")
		if currentModule then
			-- print("📅 [SERVER " .. os.date("%X") .. "] Messaggio:", currentModule.getMessage())
			print("🧮 [SERVER] Calcolo 5+3:", currentModule.calculate(5, 3))
		end
	end
end)

print(
	"💡 [SERVER] Modifica 'ExampleCore.getMessage()' e vedrai i cambiamenti ogni "
		.. RewireTestConfig.SERVER_TEST_INTERVAL
		.. " secondi!"
)
