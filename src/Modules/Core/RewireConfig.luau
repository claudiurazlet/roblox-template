--[[
	RewireConfig.luau
	Configurazione semplice per Rewire Hot Reloading
	
	IMPORTANTE: Server e Client configurano separatamente i moduli condivisi.
	Questo è necessario perché:
	- Ogni processo (server/client) ha la sua istanza dei moduli
	- Rewire funziona localmente in ogni ambiente  
	- I moduli condivisi vengono hot-reloaded indipendentemente in ogni contesto
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- local DevPackages = ReplicatedStorage:WaitForChild("DevPackages")
-- local Rewire = require(DevPackages.Rewire)
local DevPackages = ReplicatedStorage:WaitForChild("DevPackages")
local Rewire = require(DevPackages.Rewire)



local RewireConfig = {}

-- Tabella per tenere traccia dei moduli caricati
local loadedModules: { [ModuleScript]: any } = {}
-- Registro per trovare moduli per nome
local moduleRegistry: { [string]: ModuleScript } = {}
local hotReloader: any = nil

-- Funzione helper per configurare il hot reloading ricorsivamente su una cartella
local function setupHotReloadingForFolder(folder: Instance, basePath: string?)
	basePath = basePath or folder.Name

	for _, child in folder:GetChildren() do
		if child:IsA("ModuleScript") then
			-- Setup hot reloading per questo modulo
			local modulePath = basePath .. "/" .. child.Name
			print("Setting up hot reloading for:", modulePath)

			-- Registra il modulo per nome
			moduleRegistry[child.Name] = child
			moduleRegistry[modulePath] = child

			hotReloader:listen(child, function(moduleScript: ModuleScript, context)
				-- Callback quando il modulo viene caricato/ricaricato
				loadedModules[child] = require(moduleScript)

				if context.isReloading then
					print("🔥 Hot reloaded:", modulePath)
				else
					print("📦 Loaded:", modulePath)
				end
			end, function(moduleScript: ModuleScript, context)
				-- Cleanup callback prima del reload
				if loadedModules[child] then
					local module = loadedModules[child]
					if typeof(module) == "table" and module.Destroy then
						module:Destroy()
					end
				end
			end)
		elseif child:IsA("Folder") then
			-- Ricorsione nelle sottocartelle
			local newPath = basePath .. "/" .. child.Name
			setupHotReloadingForFolder(child, newPath)
		end
	end
end

-- Funzione per ottenere un modulo caricato (sempre la versione più recente)
function RewireConfig.getModule(moduleScript: ModuleScript)
	return loadedModules[moduleScript]
end

-- Funzione per ottenere un modulo per nome (sempre la versione più recente)
function RewireConfig.getModuleByName(moduleName: string)
	local moduleScript = moduleRegistry[moduleName]
	if moduleScript then
		return loadedModules[moduleScript]
	end
	warn("Module not found:", moduleName)
	return nil
end

local function setupHotReloadingForServerFolder(folder: string)
	local serverClasses = ServerScriptService:FindFirstChild(folder)
	if serverClasses then
		setupHotReloadingForFolder(serverClasses, folder)
	else
		warn("Folder not found under Server: ", folder)
	end
end

local function setupHotReloadingForReplicatedStorageFolder(folder: string)
	local sharedFolder = ReplicatedStorage:FindFirstChild("Shared"):FindFirstChild(folder)
	if sharedFolder then
		setupHotReloadingForFolder(sharedFolder, folder)
	else
		warn("Folder not found under ReplicatedStorage: ", folder)
	end
end

local function setupReplicatedStorage()
	setupHotReloadingForReplicatedStorageFolder("Classes")
	setupHotReloadingForReplicatedStorageFolder("Modules")
	setupHotReloadingForReplicatedStorageFolder("Services")
	-- setupHotReloadingForReplicatedStorageFolder("Test")
end

-- Funzione per configurare rewire per il server
function RewireConfig.setupServer()
	if hotReloader then
		return hotReloader
	end

	hotReloader = Rewire.HotReloader.new()

	setupHotReloadingForServerFolder("Classes")
	setupHotReloadingForServerFolder("Modules")
	setupHotReloadingForServerFolder("Services")
	-- setupHotReloadingForServerFolder("Test")

	setupReplicatedStorage()

	return hotReloader
end

-- Funzione per configurare rewire per il client
function RewireConfig.setupClient()
	if hotReloader then
		return hotReloader
	end

	hotReloader = Rewire.HotReloader.new()

	-- Il client configura hot reloading SOLO per i moduli condivisi
	-- (stesso behavior del server per i moduli shared, ma separato)
	setupReplicatedStorage()

	-- Nota: Il client NON gestisce moduli server-only per ovvie ragioni di sicurezza

	return hotReloader
end

-- Funzione di utilità per ottenere il reloader appropriato
function RewireConfig.getReloader()
	if RunService:IsServer() then
		return RewireConfig.setupServer()
	else
		return RewireConfig.setupClient()
	end
end

-- Funzione per inizializzare tutto automaticamente
function RewireConfig.init()
	local reloader = RewireConfig.getReloader()
	print("Rewire hot reloading configured for", RunService:IsServer() and "Server" or "Client")
	return reloader
end

return RewireConfig
