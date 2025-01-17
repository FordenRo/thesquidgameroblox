local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CutsceneController = {}
CutsceneController.__index = CutsceneController

local startCutsceneRE = ReplicatedStorage.Remotes.Cutscene.Start

function CutsceneController.new()
	local self = setmetatable({}, CutsceneController)

	self.CurrentCutscene = nil

	startCutsceneRE.OnClientEvent:Connect(function(name) self:StartCutscene(name) end)

	return self
end

function CutsceneController:StartCutscene(name: string)
	self.CurrentCutscene = require(ReplicatedStorage.Shared.Modules.Cutscenes:FindFirstChild(name))
	task.spawn(function() self.CurrentCutscene:Start() end)
end

return CutsceneController.new()