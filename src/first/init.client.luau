local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game.Players.LocalPlayer

local Assets = require(script.Assets)
local LoadingScreen = require(script.LoadingScreen)

local loadingScreen = LoadingScreen.new(ReplicatedFirst.LoadingScreen)
loadingScreen.Instance.Parent = player.PlayerGui

ReplicatedFirst:RemoveDefaultLoadingScreen()

if not game:IsLoaded() then
	game.Loaded:Wait()
end

ContentProvider:PreloadAsync(Assets)

local playerLoadedRE = ReplicatedStorage.Remotes.PlayerLoaded
playerLoadedRE:FireServer()

local SpawnController = require(player.PlayerScripts.Client.Controllers.SpawnController)
SpawnController:PlayerSpawned()

loadingScreen:Hide()
