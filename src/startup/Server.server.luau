local ServerScriptService = game:GetService("ServerScriptService")
local TestServiceServer = require(ServerScriptService.Services.TestService.TestServiceServer)

TestServiceServer:init()