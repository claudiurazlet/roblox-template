local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Greeting = require(ReplicatedStorage.Shared.Modules.Core.Greeting)

return function()        
	describe("formatGreeting", function()
		it("formats the provided name", function()
			local result = Greeting.formatGreeting("Roblox")
			expect(result).to.equal("Hello, Roblox!")
		end)

		it("defaults to 'world' when no name is given", function()
			local result = Greeting.formatGreeting(nil)
			expect(result).to.equal("Hello, world!")
		end)
	end) 
end
