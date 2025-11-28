--[[
	RewireTestConfig.luau
	Configurazione per abilitare/disabilitare i test di Rewire
	
	Modifica ENABLE_TESTS per attivare/disattivare i test
]]

local RewireTestConfig = {}

-- 🔧 CONFIGURA QUI: Abilita/disabilita i test di hot reloading
RewireTestConfig.ENABLE_TESTS = true -- Cambia in true per abilitare i test

-- Configurazione test
RewireTestConfig.SERVER_TEST_INTERVAL = 5 -- secondi
RewireTestConfig.CLIENT_TEST_INTERVAL = 7 -- secondi

return RewireTestConfig
