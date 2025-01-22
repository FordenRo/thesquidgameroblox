local TweenService = game:GetService("TweenService")
local LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

function LoadingScreen.new(instance: ScreenGui)
	local self = setmetatable({}, LoadingScreen)

	self.Instance = instance

	return self
end

function LoadingScreen:BarAnimation()
	local bar = self.Instance.CanvasGroup.Frame.LoadingBar
	task.spawn(function()
		while self.Instance.Parent do
			bar.UIGradient.Offset = Vector2.xAxis * math.sin(-math.pi / 2 + time())
			task.wait()
		end
	end)
end

function LoadingScreen:Hide()
	local tween = TweenService:Create(self.Instance.CanvasGroup, TweenInfo.new(2), { GroupTransparency = 1 })
	tween.Completed:Once(function()
		self.Instance:Destroy()
	end)
	tween:Play()
end

return LoadingScreen
