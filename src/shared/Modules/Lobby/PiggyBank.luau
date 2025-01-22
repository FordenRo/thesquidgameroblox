local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local PiggyBank = {}
PiggyBank.__index = PiggyBank

local money = ReplicatedStorage.Models.Money

function PiggyBank.new(instance: Model)
	local self = setmetatable({}, PiggyBank)

	self.Instance = instance
	self.Spawner = instance:WaitForChild("Spawner")
	self.startCFrame = self.Instance:GetPivot()

	self.spawnEndEvent = Instance.new("BindableEvent")
	self.SpawnEnd = self.spawnEndEvent.Event

	self.pullEndEvent = Instance.new("BindableEvent")
	self.PullEnd = self.pullEndEvent.Event

	self.pushEndEvent = Instance.new("BindableEvent")
	self.PushEnd = self.pushEndEvent.Event

	self.MoneyParts = {}
	task.spawn(function()
		for _ = 1, 1000 do
			table.insert(self.MoneyParts, money:Clone())
		end
	end)

	return self
end

function PiggyBank:ToggleLights(state: boolean)
	for _, lightPart in self.Instance.LightParts:GetChildren() do
		lightPart:FindFirstChildOfClass("PointLight").Enabled = state
	end
end

function PiggyBank:Pull()
	local cframeValue = Instance.new("CFrameValue")
	cframeValue.Value = self.Instance:GetPivot()

	cframeValue.Changed:Connect(function(cframe)
		self.Instance:PivotTo(cframe)
	end)

	local tween = TweenService:Create(
		cframeValue,
		TweenInfo.new(20, Enum.EasingStyle.Linear),
		{ Value = self.startCFrame - Vector3.yAxis * 20 }
	)
	tween.Completed:Once(function()
		self.pullEndEvent:Fire()
	end)
	tween:Play()
end

function PiggyBank:Push()
	local cframeValue = Instance.new("CFrameValue")
	cframeValue.Value = self.Instance:GetPivot()

	cframeValue.Changed:Connect(function(cframe)
		self.Instance:PivotTo(cframe)
	end)

	local tween =
		TweenService:Create(cframeValue, TweenInfo.new(20, Enum.EasingStyle.Linear), { Value = self.startCFrame })
	tween.Completed:Once(function()
		self.pushEndEvent:Fire()
	end)
	tween:Play()
end

function PiggyBank:SpawnMoney(count: number)
	if not self.Folder then
		self.Folder = Instance.new("Folder")
		self.Folder.Name = "PiggyBankMoney"
		self.Folder.Parent = game.Workspace
	end

	task.spawn(function()
		for _ = 1, count do
			task.wait(1 / 10)

			local clone = self.MoneyParts[1]
			clone.CFrame = CFrame.lookAlong(self.Spawner.Position, Random.new():NextUnitVector())
			clone.Anchored = false
			clone.Parent = self.Folder
			table.remove(self.MoneyParts, 1)
		end

		self.spawnEndEvent:Fire()
	end)
end

function PiggyBank:DespawnMoney()
	self.Folder:Destroy()
	self.Folder = nil
end

return PiggyBank
