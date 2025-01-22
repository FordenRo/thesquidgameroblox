local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local SpawnController = {}
SpawnController.__index = SpawnController

local player: Player = game.Players.LocalPlayer
local wakeScreenCoverRE = ReplicatedStorage.Remotes.WakeScreenCover

function SpawnController.new()
	local self = setmetatable({}, SpawnController)

	wakeScreenCoverRE.OnClientEvent:Connect(function()
		self:WakeScreenCover()
	end)

	return self
end

function SpawnController:PlayerSpawned()
	local screenCover = player.PlayerGui:WaitForChild("ScreenCover") :: NumberValue
	screenCover.Value = 1

	task.delay(2, function()
		local tween = TweenService:Create(screenCover, TweenInfo.new(2), { Value = 0 })
		tween:Play()
	end)
end

function SpawnController:WakeScreenCover()
	local screenCover = player.PlayerGui:FindFirstChild("ScreenCover") :: NumberValue

	do
		local tween = TweenService:Create(screenCover, TweenInfo.new(0.2), { Value = 1 })
		tween:Play()
		tween.Completed:Wait()
	end

	task.delay(0.7, function()
		local tween = TweenService:Create(screenCover, TweenInfo.new(0.8), { Value = 0 })
		tween:Play()
	end)
end

return SpawnController.new()
