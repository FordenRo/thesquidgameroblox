local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MovementController = {}
MovementController.__index = MovementController

local player = game.Players.LocalPlayer
local toggleMovementRE = ReplicatedStorage.Remotes.ToggleMovement

local Controller = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

local SPRINT_MULTIPLIER = 1.5

function MovementController.new()
	local self = setmetatable({}, MovementController)

	ContextActionService:BindAction("Sprint", function(_, inputState)
		self:Sprint(inputState)
	end, false, Enum.KeyCode.LeftShift)
	toggleMovementRE.OnClientEvent:Connect(function(...)
		self:ToggleMovement(...)
	end)
	player.CharacterAdded:Connect(function()
		self:CharacterAdded()
	end)

	return self
end

function MovementController:ToggleMovement(state: boolean)
	if state then
		Controller:Enable()
	else
		Controller:Disable()
	end
end

function MovementController:CharacterAdded()
	self.Humanoid = player.Character:WaitForChild("Humanoid")
	self.WalkSpeed = self.Humanoid.WalkSpeed
end

function MovementController:Sprint(inputState: Enum.UserInputState)
	if not self.Humanoid then
		return
	end

	if inputState == Enum.UserInputState.Begin then
		self.Humanoid.WalkSpeed = self.WalkSpeed * SPRINT_MULTIPLIER
	elseif inputState == Enum.UserInputState.End then
		self.Humanoid.WalkSpeed = self.WalkSpeed
	end
end

return MovementController.new()
