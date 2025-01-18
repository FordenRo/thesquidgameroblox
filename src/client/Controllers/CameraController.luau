local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local CameraController = {}
CameraController.__index = CameraController

local Lerp = require(ReplicatedStorage.Shared.Utils.Lerp)

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local attachCameraRE = game.ReplicatedStorage.Remotes.Camera.Attach
local resetCameraRE = game.ReplicatedStorage.Remotes.Camera.Reset

function CameraController.new()
	local self = setmetatable({}, CameraController)

	self.AttachToPart = nil

	camera.CameraType = Enum.CameraType.Custom

	RunService:BindToRenderStep("CameraRender", Enum.RenderPriority.Camera.Value + 1, function(...)
		self:CameraRender(...)
	end)

	player.CharacterAdded:Connect(function()
		self:CharacterAdded()
	end)
	attachCameraRE.OnClientEvent:Connect(function(...)
		self:AttachCamera(...)
	end)
	resetCameraRE.OnClientEvent:Connect(function()
		self:ResetCamera()
	end)

	return self
end

function CameraController:CharacterAdded()
	self.Angle = 0
	self.Roll = 0
	self.walkTime = 0
	self.Humanoid = player.Character:WaitForChild("Humanoid")
end

function CameraController:AttachCamera(instance: BasePart)
	self.AttachToPart = instance
	camera.CameraType = Enum.CameraType.Scriptable
	player.CameraMode = Enum.CameraMode.Classic
end

function CameraController:ResetCamera()
	self.AttachToPart = nil
	camera.CameraType = Enum.CameraType.Custom
	player.CameraMode = Enum.CameraMode.LockFirstPerson
end

function CameraController:CameraRender(deltaTime: number)
	if not player.Character then
		return
	end

	if not self.Humanoid then
		return
	end

	local head: BasePart = player.Character:FindFirstChild("Head")
	if not head then
		return
	end

	if self.AttachToPart then
		camera.CFrame = self.AttachToPart:GetPivot()
		return
	end

	if self.Humanoid.Health == 0 then
		camera.CFrame = head.CFrame
		return
	end

	local rootPart: BasePart = player.Character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return
	end

	local neck = head:FindFirstChild("Neck") :: Motor6D

	local relativeVelocity = rootPart.CFrame:ToObjectSpace(rootPart.CFrame - rootPart.AssemblyLinearVelocity).Position
	self.Roll = Lerp(self.Roll, math.clamp(relativeVelocity.X / 4, -10, 10), deltaTime * 4)
	self.walkTime += deltaTime * relativeVelocity.Z / 3

	local relativeCameraDirection = rootPart.CFrame:ToObjectSpace(camera.CFrame).LookVector
	neck.C0 = CFrame.new(neck.C0.Position) * CFrame.Angles(math.asin(relativeCameraDirection.Y), 0, 0)

	self.Humanoid.CameraOffset = rootPart.CFrame:ToObjectSpace(head.CFrame).Position - Vector3.new(0, 1.5, 0.5)

	camera.CFrame = camera.CFrame
		* CFrame.Angles(
			math.rad(math.cos(self.walkTime * 2) * deltaTime * relativeVelocity.Z / 3),
			math.rad(math.sin(self.walkTime) * deltaTime * relativeVelocity.Z / 3),
			math.rad(self.Roll)
		)
end

return CameraController.new()
