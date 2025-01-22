local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Cutscene = {}
Cutscene.__index = Cutscene

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local nextMarkerRE = ReplicatedStorage.Remotes.Cutscene.Marker

local MovementController = require(player.PlayerScripts.Client.Controllers.MovementController)
local Subtitles = require(ReplicatedStorage.Shared.Modules.Subtitles)

local SRT = [[
00:00:00,000
Я хотел бы от всего сердца поприветствовать всех вас.

00:00:03,500
В течении шести дней, все вы примете участие в шести играх.

00:00:07,000
Победившие во всех шести играх получат крупный денежный приз.

00:00:11,500
Мы были вынуждены скрыть наши лица,

00:00:13,500
это гарантирует честность и конфиденциальность.

00:00:16,500
Также чтобы игры проходили гладко, мы одели вас в форму.

00:00:20,000
Вся ваша одежда и принадлежности в безопасном месте, мы вернем их по окончанию игр.

00:00:26,000
Все вы,

00:00:27,500
в этом зале,

00:00:29,000
Находитесь в отчаянном положении и не можете выплатить свои долги.
]]

function Cutscene.new()
	return setmetatable({}, Cutscene)
end

function Cutscene:Start()
	MovementController:ToggleMovement(false)
	camera.CameraType = Enum.CameraType.Scriptable

	local startCameraFOV = camera.FieldOfView
	local cameraTarget = game.Workspace.Lobby.Entrance.MainDoorway.DoubleDoor:GetPivot().Position
	local squareGuy = game.Workspace.Lobby.Entrance.PinkGuys.SquareGuy
	local squareGuyHead = squareGuy.Head

	do
		local fov = math.clamp(140 - (camera.CFrame.Position - cameraTarget).Magnitude, 10, 70)
		local tween = TweenService:Create(
			camera,
			TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{ CFrame = CFrame.new(camera.CFrame.Position, cameraTarget), FieldOfView = fov }
		)
		tween:Play()
	end

	nextMarkerRE.OnClientEvent:Wait()
	task.wait(1)

	local audioAnalyzer = squareGuy:FindFirstChildOfClass("AudioAnalyzer")
	local speakAnimTask = task.spawn(function()
		local head = squareGuy:FindFirstChild("Head")
		local neck = head:FindFirstChild("Neck") :: Motor6D
		while true do
			local _, deltaTime = RunService.Stepped:Wait()

			local angle = math.rad(audioAnalyzer.RmsLevel * 50)
			neck.C0 = neck.C0:Lerp(CFrame.new(neck.C0.Position) * CFrame.Angles(angle, 0, 0), deltaTime * 8)
		end
	end)

	local function lookAtSquareGuy()
		camera.CFrame = CFrame.new(Vector3.new(squareGuyHead.Position.X, 12, -86), squareGuyHead.Position)
	end

	camera.FieldOfView = startCameraFOV

	camera.CFrame = CFrame.new(squareGuyHead.Position + Vector3.new(0, 0.5, 3), squareGuyHead.Position)

	do
		local _task = task.spawn(function()
			while true do
				local deltaTime = RunService.RenderStepped:Wait()
				local targetCFrame = CFrame.new(
					Vector3.new(squareGuyHead.Position.X, 11.5, squareGuyHead.Position.Z + 6),
					Vector3.new(squareGuyHead.Position.X, 11, squareGuyHead.Position.Z)
				)
				camera.CFrame = camera.CFrame:Lerp(targetCFrame, deltaTime * 3)
			end
		end)
		nextMarkerRE.OnClientEvent:Wait()
		task.cancel(_task)
	end

	do
		local tween = TweenService:Create(
			camera,
			TweenInfo.new(0.8, Enum.EasingStyle.Sine),
			{ CFrame = CFrame.new(squareGuyHead.Position + Vector3.new(0, 1, 6), squareGuyHead.Position) }
		)
		tween:Play()
		task.wait(1)
	end

	camera.CFrame = CFrame.new(Vector3.new(squareGuyHead.Position.X, 15, -101))
		* CFrame.fromOrientation(math.rad(-12), math.pi, 0)

	do
		local tween = TweenService:Create(camera, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {
			CFrame = CFrame.new(squareGuyHead.Position.X, 15, -98) * CFrame.fromOrientation(math.rad(-8), math.pi, 0),
		})
		tween:Play()
		tween.Completed:Wait()
	end

	Subtitles.new(SRT):Start()
	lookAtSquareGuy()
	task.wait(6)

	camera.CFrame = CFrame.new(-40, 34, -74) * CFrame.fromOrientation(math.rad(-20), math.rad(-135), 0)
	task.wait(3)

	lookAtSquareGuy()
	task.wait(8)

	camera.CFrame = CFrame.new(Vector3.new(22, 15, -60), squareGuyHead.Position)

	do
		local tween = TweenService:Create(
			camera,
			TweenInfo.new(6, Enum.EasingStyle.Linear),
			{ CFrame = CFrame.new(Vector3.new(19, 14, -66), squareGuyHead.Position) }
		)
		tween:Play()
		tween.Completed:Wait()
	end

	lookAtSquareGuy()
	task.wait(6)

	camera.CFrame = CFrame.new(squareGuyHead.Position.X, 33, -78) * CFrame.fromOrientation(math.rad(-18), math.pi, 0)
	task.wait(4)

	lookAtSquareGuy()
	nextMarkerRE.OnClientEvent:Wait()

	camera.CFrame = CFrame.new(-35, 30, 50) * CFrame.fromOrientation(math.rad(-7), math.rad(-28), 0)
end

return Cutscene.new()
