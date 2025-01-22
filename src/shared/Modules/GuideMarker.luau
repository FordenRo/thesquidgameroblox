local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GuideMarker = {}
GuideMarker.__index = GuideMarker

local instance = ReplicatedStorage.Models.GuideMarker

function GuideMarker.new(position: Vector3)
	local self = setmetatable({}, GuideMarker)

	self.Instance = instance:Clone()
	self.Instance:MoveTo(position)
	self.Instance.Parent = game.Workspace

	local point = self.Instance:FindFirstChild("Point")
	task.spawn(function()
		while self.Instance.Parent do
			local y = 3 + math.sin(time() * 4) * 0.7
			point.CFrame = self.Instance:GetPivot() + Vector3.yAxis * y
			task.wait()
		end
	end)

	return self
end

function GuideMarker:Destroy()
	self.Instance:Destroy()
end

return GuideMarker
