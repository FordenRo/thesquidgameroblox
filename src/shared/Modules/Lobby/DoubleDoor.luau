local TweenService = game:GetService("TweenService")

local DoubleDoor = {}
DoubleDoor.__index = DoubleDoor

local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function DoubleDoor.new(instance: Model)
	local self = setmetatable({}, DoubleDoor)

	self.Instance = instance
	self.Left = self.Instance.Left
	self.Right = self.Instance.Right

	self.leftStartCFrame = self.Left.CFrame
	self.rightStartCFrame = self.Right.CFrame

	self.leftTargetCFrame = self.Left.Target.WorldCFrame
	self.rightTargetCFrame = self.Right.Target.WorldCFrame

	return self
end

function DoubleDoor:Open()
	local leftTween = TweenService:Create(self.Left, tweenInfo, { CFrame = self.leftTargetCFrame })
	local rightTween = TweenService:Create(self.Right, tweenInfo, { CFrame = self.rightTargetCFrame })

	leftTween:Play()
	rightTween:Play()
end

function DoubleDoor:Close()
	local leftTween = TweenService:Create(self.Left, tweenInfo, { CFrame = self.leftStartCFrame })
	local rightTween = TweenService:Create(self.Right, tweenInfo, { CFrame = self.rightStartCFrame })

	leftTween:Play()
	rightTween:Play()
end

return DoubleDoor
