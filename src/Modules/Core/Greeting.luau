local Greeting = {}

function Greeting.formatGreeting(name: string?): string
	local target = name or "world"
	return "Hello, " .. target .. "!"
end

return Greeting
