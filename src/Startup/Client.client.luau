local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuildServiceClient = require(ReplicatedStorage.Shared.Services.BuildService.BuildServiceClient)

BuildServiceClient:init()
