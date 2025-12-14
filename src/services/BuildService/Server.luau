local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local Spike = require(ReplicatedStorage.Shared.Classes.Spike)

local BUILD_COOLDOWN = 0.1 -- seconds
local BuildServiceServer = {}

function BuildServiceServer.init(self: BuildServiceServer)
    self.previousBuildTime = 0
    self.networker = Networker.server.new("BuildService", self, {
        self.attemptBuild,
    })
end

function BuildServiceServer.attemptBuild(self: BuildServiceServer, player: Player, cf: CFrame)
    local timeSinceLastBuild = os.time() - self.previousBuildTime
    if timeSinceLastBuild < BUILD_COOLDOWN then
        warn("Player " .. player.Name .. " is building too quickly! Ignoring build request.")
        return
    end
    
    self.previousBuildTime = os.time()

    local spike = Spike.new(cf)
    task.wait(10)
    spike:destroy()
end

-- MEMBER VARIABLES ARE DEFINED WITH INSIDE "& {}"
type BuildServiceServer = typeof(BuildServiceServer) & {
    previousBuildTime: number,
    networker: Networker.Server
}

return BuildServiceServer :: BuildServiceServer