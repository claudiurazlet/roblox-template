local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Networker = require(ReplicatedStorage.Packages.Networker)
local Spike = require(ReplicatedStorage.Shared.Classes.Spike)

local BuildServiceServer = {}

local BUILD_COOLDOWN = 0.1 -- seconds
local lastBuildTimeByKey: { [any]: number } = {}

function BuildServiceServer:init()
	self.networker = Networker.server.new("BuildService", self, {
		self.attemptBuild,
	})

	-- CLEANUP COOLDOWN CACHE WHEN PLAYERS LEAVE
	Players.PlayerRemoving:Connect(function(player: Player)
		lastBuildTimeByKey[player] = nil
	end)
end

function BuildServiceServer:attemptBuild(player: Player, cf: CFrame)
	if self:isInCooldown(player) then
		warn("Player " .. player.Name .. " is building too quickly! Ignoring build request.")
		return false
	end

	lastBuildTimeByKey[player] = os.clock()

	local spike = Spike.new(cf)
	task.delay(10, function()
		spike:destroy()
	end)

	return true
end

function BuildServiceServer:isInCooldown(player: Player): boolean
	return self:getCooldown(player) < BUILD_COOLDOWN
end

function BuildServiceServer:getBuildCooldown(): number
	return BUILD_COOLDOWN
end

function BuildServiceServer:getCooldown(player: Player): number
	local lastBuildTime = lastBuildTimeByKey[player]
	if lastBuildTime == nil then
		return math.huge
	end

	return os.clock() - lastBuildTime
end

-- MEMBER VARIABLES ARE DEFINED INSIDE "& {}"
type BuildServiceServer = typeof(BuildServiceServer) & {
	networker: Networker.Server,
}

return BuildServiceServer :: BuildServiceServer
