local RunService = game:GetService("RunService")
local CharacterVisibility = {}
CharacterVisibility.__index = CharacterVisibility

local player = game.Players.LocalPlayer

local VISIBLE_PARTS = {
	"LeftFoot",
	"LeftLowerLeg",
	"LeftUpperLeg",
	"LeftLowerArm",
	"LeftUpperArm",
	"LeftHand",
	"LowerTorso",
	"RightFoot",
	"RightLowerLeg",
	"RightUpperLeg",
	"RightLowerArm",
	"RightUpperArm",
	"RightHand",
	"UpperTorso",
}

function CharacterVisibility.new()
	local self = setmetatable({}, CharacterVisibility)

	self.Visible = true

	RunService:BindToRenderStep("CharacterVisibility", Enum.RenderPriority.Camera.Value + 1, function()
		self:setCharacterVisibility()
	end)

	return self
end

function CharacterVisibility:Enable()
	self.Visible = true
end

function CharacterVisibility:Disable()
	self.Visible = false
end

function CharacterVisibility:setCharacterVisibility()
	if not player.Character then
		return
	end

	for _, v: BasePart in player.Character:GetDescendants() do
		if not v:IsA("BasePart") then
			continue
		end

		if table.find(VISIBLE_PARTS, v.Name) then
			v.LocalTransparencyModifier = 0
		else
			v.LocalTransparencyModifier = 1
		end
	end
end

return CharacterVisibility.new()
