local TestServiceUtils = {}

function TestServiceUtils.init(self: TestServiceUtils)
	print("hi from TestServiceUtils!")
end

export type TestServiceUtils = typeof(TestServiceUtils) & {}

return TestServiceUtils

