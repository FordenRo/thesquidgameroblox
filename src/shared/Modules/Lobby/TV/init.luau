local Players = game:GetService("Players")

local TV = {}
TV.__index = TV

local PlayerCountText = require(script.PlayerCountText)

function TV.new(instance: Model)
	local self = setmetatable({}, TV)

	self.Instance = instance
	self.PlayerCountText = PlayerCountText.new(self.Instance.Screen.SurfaceGui.PlayerCount)

	self.PlayerCountText:SetPlayerCount(0)

	Players.PlayerAdded:Connect(function()
		self:UpdatePlayerCount()
	end)
	Players.PlayerRemoving:Connect(function()
		self:UpdatePlayerCount()
	end)

	return self
end

function TV:UpdatePlayerCount()
	self.PlayerCountText:SetPlayerCount(#Players:GetPlayers())
end

return TV
