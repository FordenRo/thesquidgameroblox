local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Cutscene = {}
Cutscene.__index = Cutscene

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local nextMarkerRE = game.ReplicatedStorage.Remotes.Cutscene.Marker

local MovementController = require(player.PlayerScripts.Client.Controllers.MovementController)
local Subtitles = require(ReplicatedStorage.Shared.Modules.Subtitles)

local SRT = [[
1
00:00:00,000 --> 00:00:02,800
Я хотел бы от всего сердца поприветствовать всех вас.

2
00:00:03,200 --> 00:00:06,600
В течении шести дней, все вы примете участие в шести играх.

3
00:00:07,000 --> 00:00:10,320
Победившие во всех шести играх получат крупный денежный приз.
]]

function Cutscene.new()
	return setmetatable({}, Cutscene)
end

function Cutscene:Start()
	MovementController:ToggleMovement(false)
	camera.CameraType = Enum.CameraType.Scriptable

	local startCameraFOV = camera.FieldOfView
	local cameraTarget = game.Workspace.Lobby.Entrance.MainDoorway.DoubleDoor:GetPivot().Position
	local squareGuyHead = game.Workspace.Lobby.Entrance.PinkGuys.SquareGuy.Head
	local cameraCFrame = CFrame.new(camera.CFrame.Position, cameraTarget)
	local fov = math.clamp(120 - (camera.CFrame.Position - cameraTarget).Magnitude, 20, 70)
	print((camera.CFrame.Position - cameraTarget).Magnitude)
	print(fov)
	local tween = TweenService:Create(
		camera,
		TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
		{ CFrame = cameraCFrame, FieldOfView = fov }
	)
	tween:Play()
	nextMarkerRE.OnClientEvent:Wait()

	local function lookAtSquareGuy()
		camera.CFrame = CFrame.new(Vector3.new(squareGuyHead.Position.X, 13, -85), squareGuyHead.Position)
	end

	camera.FieldOfView = startCameraFOV
	lookAtSquareGuy()
	nextMarkerRE.OnClientEvent:Wait()
	task.wait(1)
	camera.CFrame = CFrame.new(Vector3.new(squareGuyHead.Position.X, 15, -101))
		* CFrame.fromOrientation(math.rad(-10), math.rad(180), 0)
	task.wait(2.5)
	Subtitles.new(SRT):Start()
	lookAtSquareGuy()
	task.wait(6)
	camera.CFrame = CFrame.new(Vector3.new(-40, 34, -74)) * CFrame.fromOrientation(math.rad(-20), math.rad(-135), 0)
	task.wait(3)
	lookAtSquareGuy()
	task.wait(8)
	camera.CFrame = CFrame.new(Vector3.new(20, 14, -64), squareGuyHead.Position)
	task.wait(6)
	lookAtSquareGuy()
end

return Cutscene.new()
