local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameService = {}
GameService.__index = GameService

function GameService.new()
	local self = setmetatable({}, GameService)

	self.PlayerIndexes = {} :: { Player: number }
	Players.PlayerAdded:Connect(function(player)
		self:PlayerAdded(player)
	end)

	ReplicatedStorage.Functions.GetPlayerIndex.OnServerInvoke = function(_, player: Player)
		return self.PlayerIndexes[player]
	end

	return self
end

function GameService:PlayerAdded(player: Player)
	self.PlayerIndexes[player] = self:getUniqueIndex()

	player.CharacterAdded:Connect(function(character: Model)
		local head = character:FindFirstChild("Head") :: BasePart
		head.CanCollide = true
	end)
end

function GameService:getUniqueIndex(): number
	local occupiedIndexes = {}
	for _, index: number in self.PlayerIndexes do
		table.insert(occupiedIndexes, index)
	end

	local availableIndexes = {}
	for i = 1, 456 do
		if table.find(occupiedIndexes, i) then
			continue
		end

		table.index(availableIndexes, i)
	end
	return availableIndexes[math.random(#availableIndexes)]
end

function GameService:GetPlayerIndex(player: Player): number
	return self.PlayerIndexes[player]
end

return GameService.new()
