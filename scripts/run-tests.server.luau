local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function main()
	local ok, err = pcall(function()
		local Test = require(ReplicatedStorage.Shared.Modules.Test.Runner)
		local results = Test.run()
		print(results)

		if results and results.failureCount and results.failureCount > 0 then
			error(string.format("Test failures: %d", results.failureCount))
		end
	end)

	if not ok then
		warn("[TestRunner] error: " .. tostring(err))
		error(err)
	end
end

main()
