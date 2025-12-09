local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestServiceServer = require(ServerScriptService.Services.TestService.TestServiceServer)

TestServiceServer:init()

local Test = require(ReplicatedStorage.Shared.Modules.Test.Runner)
local results = Test.run()
print(results)