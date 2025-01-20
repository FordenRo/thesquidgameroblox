local ScreenCoverController = {}
ScreenCoverController.__index = ScreenCoverController

local player = game.Players.LocalPlayer

function ScreenCoverController.new()
	local self = setmetatable({}, ScreenCoverController)

	self.ValueInstance = Instance.new("NumberValue")
	self.ValueInstance.Value = 0
	self.ValueInstance.Name = "ScreenCover"

	self.ValueInstance.Changed:Connect(function()
		self:ValueChanged()
	end)

	self.ValueInstance.Parent = player.PlayerGui

	self.Screen = Instance.new("ScreenGui")
	self.Screen.ScreenInsets = Enum.ScreenInsets.None
	self.Screen.Name = "ScreenCoverGui"

	self.CoverFrame = Instance.new("Frame")
	self.CoverFrame.Size = UDim2.fromScale(1, 1)
	self.CoverFrame.BackgroundColor3 = Color3.new()
	self.CoverFrame.BackgroundTransparency = 1
	self.CoverFrame.Parent = self.Screen

	self.Screen.Parent = player.PlayerGui

	return self
end

function ScreenCoverController:ValueChanged()
	self.CoverFrame.BackgroundTransparency = 1 - self.ValueInstance.Value
end

return ScreenCoverController.new()
