local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestServiceServer = require(ServerScriptService.Services.TestService.TestServiceServer)

TestServiceServer:init()
