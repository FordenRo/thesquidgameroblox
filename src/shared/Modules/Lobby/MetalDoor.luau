local TweenService = game:GetService("TweenService")

local MetalDoor = {}
MetalDoor.__index = MetalDoor

local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function MetalDoor.new(instance: Model)
	local self = setmetatable({}, MetalDoor)

	self.Instance = instance
	self.Hinge = self.Instance.Hinge
	self.closedCFrame = self.Hinge.CFrame
	self.openedCFrame = self.Hinge.CFrame * CFrame.Angles(0, -math.rad(120), 0)
	self.IsOpen = false

	return self
end

function MetalDoor:Open()
	if self.IsOpen then
		return
	end

	local tween = TweenService:Create(self.Hinge, tweenInfo, { CFrame = self.openedCFrame })
	tween:Play()
	self.IsOpen = true
end

function MetalDoor:Close()
	if not self.IsOpen then
		return
	end

	local tween = TweenService:Create(self.Hinge, tweenInfo, { CFrame = self.closedCFrame })
	tween:Play()
	self.IsOpen = false
end

return MetalDoor
