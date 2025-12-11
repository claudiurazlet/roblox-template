local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getTestEZ()
	local packages = ReplicatedStorage:FindFirstChild("Packages")
	assert(packages, "Packages folder missing; run `wally install`.")

	local index = packages:FindFirstChild("_Index")
	assert(index, "Packages/_Index missing; run `wally install`.")

	for _, pkg in ipairs(index:GetChildren()) do
		local module = pkg:FindFirstChild("testez")
		if module then
			return require(module)
		end
	end

	error("Could not find TestEZ in Packages/_Index")
end

local function run()
	local TestEZ = getTestEZ()
	local TestBootstrap = TestEZ.TestBootstrap
	local TextReporter = TestEZ.Reporters.TextReporter

	local testsRoot = ReplicatedStorage.Shared.Modules.Test:FindFirstChild("Specs")
	assert(testsRoot, "No Specs folder under Shared.Modules.Test")

	local results = TestBootstrap:run({ testsRoot }, TextReporter)
	return results
end

return {
	run = run,
	getTestEZ = getTestEZ,
}
