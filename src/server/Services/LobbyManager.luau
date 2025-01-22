local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LobbyManager = {}
LobbyManager.__index = LobbyManager

local DoubleDoor = require(ReplicatedStorage.Shared.Modules.Lobby.DoubleDoor)
local NPC = require(ReplicatedStorage.Shared.Modules.NPC)
local TV = require(ReplicatedStorage.Shared.Modules.Lobby.TV)
local SegmentDisplay = require(ReplicatedStorage.Shared.Modules.SegmentDisplay)
local MetalDoor = require(ReplicatedStorage.Shared.Modules.Lobby.MetalDoor)
local PiggyBank = require(ReplicatedStorage.Shared.Modules.Lobby.PiggyBank)

local lobby = game.Workspace.Lobby
local megaphonesAudioPlayer = lobby.Objects.Megaphones.AudioPlayer
local nextMarkerRE = ReplicatedStorage.Remotes.Cutscene.Marker

local VOICES = {
	"rbxassetid://104819325954369",
	"rbxassetid://72661029023058",
	"rbxassetid://71257622025012",
	"rbxassetid://130643839158305",
	"rbxassetid://128704410551742",
}
local TIME_TO_START = 120

function LobbyManager.new()
	local self = setmetatable({}, LobbyManager)

	self.MainDoubleDoor = DoubleDoor.new(lobby.Entrance.MainDoorway.DoubleDoor)
	self.SecondDoubleDoor = DoubleDoor.new(lobby.Entrance.SecondDoorway.DoubleDoor)
	self.TV = TV.new(lobby.Objects.TV)
	self.MetalDoor = MetalDoor.new(lobby.PinkRoomEntrance.MetalDoor)
	self.SegmentDisplay = SegmentDisplay.new(lobby.Objects.SegmentDisplay)
	self.PiggyBank = PiggyBank.new(lobby.PiggyBank)

	self.PinkGuys = {}
	for _, pinkGuy in lobby.Entrance.PinkGuys:GetChildren() do
		if pinkGuy.Name == "SquareGuy" then
			self.SquareGuy = NPC.new(pinkGuy)
			continue
		end

		table.insert(self.PinkGuys, NPC.new(pinkGuy))
	end

	self.EmptyBeds = {}
	for _, bedPacks in lobby.Objects.Beds:GetChildren() do
		for _, bedPack in bedPacks:GetChildren() do
			for _, bed in bedPack:GetChildren() do
				table.insert(self.EmptyBeds, bed)
			end
		end
	end

	self:Initiate()

	return self
end

function LobbyManager:Initiate()
	ReplicatedStorage.Remotes.PlayerLoaded.OnServerEvent:Connect(function(...)
		self:PlayerLoaded(...)
	end)

	task.spawn(function()
		repeat
			local remaining_time = TIME_TO_START - time()
			self.SegmentDisplay:ShowTime(remaining_time)
			self.SegmentDisplay:ToggleDots()
			task.wait(1)
		until remaining_time - 1 <= 0

		self.SegmentDisplay:Clear()
		self:Start()
	end)

	self:ToggleLights(true)
end

function LobbyManager:Start()
	self:FirstCutscene()
end

function LobbyManager:PlayerLoaded(player: Player & { Character: Model })
	player:LoadCharacter()
	task.wait(1)

	local head = player.Character:WaitForChild("Head")
	local humanoid = player.Character:WaitForChild("Humanoid") :: Humanoid
	local rootPart = player.Character:WaitForChild("HumanoidRootPart") :: BasePart
	local animator = humanoid:WaitForChild("Animator") :: Animator

	local targetBed: BasePart = self.EmptyBeds[math.random(#self.EmptyBeds)]
	table.remove(self.EmptyBeds, table.find(self.EmptyBeds, targetBed))

	rootPart.Anchored = true
	ReplicatedStorage.Remotes.Camera.Attach:FireClient(player, head)
	ReplicatedStorage.Remotes.ToggleMovement:FireClient(player, false)
	player.Character:PivotTo(targetBed:GetPivot())

	local track = animator:LoadAnimation(ReplicatedStorage.Animations.WakeCutscene)
	track:GetMarkerReachedSignal("ScreenCover"):Connect(function()
		ReplicatedStorage.Remotes.WakeScreenCover:FireClient(player)
	end)
	track:Play(0, 1)
	track.Ended:Wait()

	local raycastInfo = game.Workspace:Spherecast(
		targetBed:GetPivot().Position + targetBed:GetPivot().RightVector * 4,
		1,
		-Vector3.yAxis * 30
	) :: RaycastResult
    player.Character:PivotTo(CFrame.new(raycastInfo.Position, raycastInfo.Position + targetBed:GetPivot().RightVector))
    rootPart.Anchored = false
    ReplicatedStorage.Remotes.Camera.Reset:FireClient(player)
    ReplicatedStorage.Remotes.ToggleMovement:FireClient(player, true)
end

function LobbyManager:ToggleLights(state: boolean)
	local enabledColor = Color3.new(1, 1, 1)
	local disabledColor = Color3.new(0.3, 0.3, 0.3)
	local color = if state then enabledColor else disabledColor

	local light = lobby.Ceil.LightPart:FindFirstChildOfClass("SurfaceLight")
	local lamps = lobby.Ceil.Lamps:GetChildren()
	for _, lamp in lamps do
		lamp.Neon.Neon.Color = color
	end
	light.Enabled = state
end

function LobbyManager:FirstCutscene()
	local audioPlayer = self.SquareGuy.Character:FindFirstChildOfClass("AudioPlayer")

	local function talkAndWait(assetId: string)
		audioPlayer.AssetId = assetId
		audioPlayer:Play()
		audioPlayer.Ended:Wait()
	end

	self.SecondDoubleDoor:Open()
	task.wait(3)

	ReplicatedStorage.Remotes.Cutscene.Start:FireAllClients("LobbyEntrance")
	self.MainDoubleDoor:Open()
	task.wait(3.5)

	task.delay(5, function()
		self.SecondDoubleDoor:Close()
	end)
	task.delay(10, function()
		self.MainDoubleDoor:Close()
	end)

	for _, pinkGuy in self.PinkGuys do
		local target = pinkGuy.Character.Target
		pinkGuy:WalkTo(target.Position, 4)
		pinkGuy.WalkToFinished:Once(function()
			pinkGuy:LookAt(pinkGuy:GetPivot().Position + target.CFrame.LookVector)
		end)
	end
	self.SquareGuy:WalkTo(self.SquareGuy.Character.Target.Position, 4)
	self.SquareGuy.WalkToFinished:Wait()
	nextMarkerRE:FireAllClients()
	task.wait(1)

	local nextTarget = self.SquareGuy.Character.NextTarget
	self.SquareGuy:WalkTo(nextTarget.Position, 3)
	self.SquareGuy.WalkToFinished:Wait()
	self.SquareGuy:LookAt(self.SquareGuy:GetPivot().Position + nextTarget.CFrame.LookVector)
	nextMarkerRE:FireAllClients()
	task.wait(4)

	talkAndWait(VOICES[1])
	task.wait(0.5)
	talkAndWait(VOICES[2])
	task.wait(0.5)
	talkAndWait(VOICES[3])
	task.wait(0.1)
	talkAndWait(VOICES[4])
	task.wait(1)
	nextMarkerRE:FireAllClients()
	task.wait(1)

	self:ToggleLights(false)
	self.PiggyBank:ToggleLights(true)
	self.PiggyBank:Pull()
	self.PiggyBank.PullEnd:Wait()
end

return LobbyManager.new()
