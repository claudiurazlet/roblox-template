local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SiftExamples = require(ReplicatedStorage.Shared.Examples.Sift.SiftExamples)
local TestServiceServer = require(ServerScriptService.Services.TestService.TestServiceServer)

TestServiceServer:init()

-- TEST SIFT
SiftExamples.runAllExamples()
SiftExamples.testImmutability()

-- RUN TESTS
local Test = require(ReplicatedStorage.Shared.Modules.Test.Runner)
local results = Test.run()
print(results)