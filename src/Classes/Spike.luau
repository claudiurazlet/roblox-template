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

	self.part = self:_createSpikePart(cf)

	return self
end


function Spike:_createSpikePart(cf: CFrame): BasePart
	-- FALLBACK FOR TEST/HEADLESS ENVIRONMENTS WHERE ASSETS MAY NOT EXIST
	local assetsFolder = ReplicatedStorage:FindFirstChild("Assets")
	local spikeTemplate = if assetsFolder then assetsFolder:FindFirstChild("Spike") else nil

	local part: BasePart
	if spikeTemplate and spikeTemplate:IsA("BasePart") then
		part = spikeTemplate:Clone()
	else
		part = Instance.new("Part")
		part.Name = "Spike"
		part.Size = Vector3.new(2, 2, 2)
	end

	part.Anchored = true
	part.CFrame = cf
	part.Parent = workspace
	part.Touched:Connect(function(hit: BasePart)
		self:partTouched(hit)
	end)

	return part
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
