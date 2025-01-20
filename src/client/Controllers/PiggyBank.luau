local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PiggyBank = {}
PiggyBank.__index = PiggyBank

local money = ReplicatedStorage.Money
local instance = game.Workspace.Lobby.Piggy

function PiggyBank.new()
	local self = setmetatable({}, PiggyBank)

	self.Spawner = instance:WaitForChild("Spawner")

	self.spawnEndEvent = Instance.new("BindableEvent")
	self.SpawnEnd = self.spawnEndEvent.Event

	self.MoneyParts = {}
	task.spawn(function()
		for i = 1, 1000 do
			table.insert(self.MoneyParts, money:Clone())
		end
	end)

	return self
end

function PiggyBank:SpawnMoney(count: number)
	if not self.Folder then
		self.Folder = Instance.new("Folder")
		self.Folder.Name = "PiggyBankMoney"
		self.Folder.Parent = game.Workspace
	end

	task.spawn(function()
		for i = 1, count do
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

return PiggyBank.new()
