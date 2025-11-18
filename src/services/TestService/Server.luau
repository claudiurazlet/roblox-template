local Test3ServiceServer = {}

function Test3ServiceServer.init(self: Test3ServiceServer)
	print("hi from Test3ServiceServer!")
end

export type Test3ServiceServer = typeof(Test3ServiceServer) & {}

return Test3ServiceServer

