--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local camera = workspace.CurrentCamera

local BuildServiceClient = {}

function BuildServiceClient.init(self: BuildServiceClient)
    self.networker = Networker.client.new("BuildService", self)

    UserInputService.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        local ray = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * 100)
        if result then
            self:build(CFrame.new(result.Position))
        end
    end)
end

function BuildServiceClient.build(self: BuildServiceClient, cf: CFrame)
    self.networker:fire("attemptBuild", cf)
end

-- MEMBER VARIABLES ARE DEFINED WITH INSIDE "& {}"
type BuildServiceClient = typeof(BuildServiceClient) & {
    networker: Networker.Client,
}

return BuildServiceClient :: BuildServiceClient
