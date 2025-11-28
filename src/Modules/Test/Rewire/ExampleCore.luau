--[[
	ExampleCoreModule.luau
	Modulo di esempio nel Core condiviso per testare il hot reloading
]]

local ExampleCore = {}

function ExampleCore.getMessage()
	return "Hello from Shared Core Module! (Version 4.0) - Timestamp: " .. os.date("%X")
end

function ExampleCore.calculate(a: number, b: number): number
	return a + b + 100
end

function ExampleCore.printInfo()
	print("ExampleCoreModule is running - you can edit this and see changes live!")
end

return ExampleCore
