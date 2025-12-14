local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestServiceServer = require(ServerScriptService.Services.TestService.TestServiceServer)
local BuildServiceServer = require(ServerScriptService.Services.BuildService.BuildServiceServer)


-- INITIALIZE SERVICES
TestServiceServer:init()
BuildServiceServer:init()


-- RUN TESTS
local Test = require(ReplicatedStorage.Shared.Modules.Test.Runner)
local results = Test.run()
print(results)
