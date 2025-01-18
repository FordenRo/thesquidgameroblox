local Players = game:GetService("Players")

local GameService = {}
GameService.__index = GameService

function GameService.new()
	local self = setmetatable({}, GameService)

	self.PlayerIndexes = {} :: { Player: number }
	Players.PlayerAdded:Connect(function(player)
		self:PlayerAdded(player)
	end)

	return self
end

function GameService:PlayerAdded(player: Player)
	self.PlayerIndexes[player] = self:getUniqueIndex()
end

function GameService:getUniqueIndex(): number
	local occupiedIndexes = {}
	for _, index: number in self.PlayerIndexes do
		table.insert(occupiedIndexes, index)
	end

	if #occupiedIndexes == 0 then
		return 1
	end

	for i = 1, occupiedIndexes[#occupiedIndexes] do
		if table.find(occupiedIndexes, i) then
			continue
		end

		return i
	end
	return occupiedIndexes[#occupiedIndexes] + 1
end

function GameService:GetPlayerIndex(player: Player): number
	return self.PlayerIndexes[player]
end

return GameService.new()
