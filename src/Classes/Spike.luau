local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Spike = {}
Spike.__index = Spike

export type Spike = typeof(setmetatable(
	{} :: {
		cf: CFrame,
		hits: { [Player]: boolean },
		part: BasePart,
	},
	Spike
))

function Spike.new(cf: CFrame): Spike
	local self: Spike = setmetatable(
		{
			cf = cf,
			hits = {},
		} :: any,
		Spike
	)

	local part = ReplicatedStorage.Assets.Spike:Clone()
	part.Anchored = true
	part.CFrame = cf
	part.Parent = workspace
	part.Touched:Connect(function(hit: BasePart)
		self:partTouched(hit)
	end)
	self.part = part

	return self
end

function Spike:partTouched(hit: BasePart): ()
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player or self.hits[player] then
        return
	end
	self.hits[player] = true
    player.Character.Humanoid:TakeDamage(25)
	-- print("Spike at " .. tostring(self.cf) .. " hit player " .. player.Name)
end

function Spike:destroy(): ()
    self.part:Destroy()
end

return Spike
