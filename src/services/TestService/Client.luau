local TestServiceClient = {}

function TestServiceClient.init(self: TestServiceClient)
	print("hi from TestServiceClient!")
end

export type TestServiceClient = typeof(TestServiceClient) & {}

return TestServiceClient

