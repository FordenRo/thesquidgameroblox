local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameService = require(script.Parent.GameService)

local AppearanceService = {}
AppearanceService.__index = AppearanceService

local labels = ReplicatedStorage.Labels
local ALLOWED_ACCESSORY_TYPES = {
	Enum.AccessoryType.Face,
	Enum.AccessoryType.Hair,
	Enum.AccessoryType.Eyebrow,
	Enum.AccessoryType.Eyelash,
	Enum.AccessoryType.LeftShoe,
	Enum.AccessoryType.RightShoe,
	Enum.AccessoryType.Neck,
}

function AppearanceService.new()
	local self = setmetatable({}, AppearanceService)

	Players.PlayerAdded:Connect(function(player)
		self:PlayerAdded(player)
	end)

	return self
end

function AppearanceService:PlayerAdded(player: Player)
	player.CharacterAppearanceLoaded:Connect(function(character: Model)
		for _, child in character:GetChildren() do
			if child:IsA("Accessory") then
				if table.find(ALLOWED_ACCESSORY_TYPES, child.AccessoryType) then
					continue
				end

				child:Destroy()
			elseif child:IsA("ShirtGraphic") then
				child:Destroy()
			end
		end

		local shirt = character:FindFirstChildOfClass("Shirt")
		local pants = character:FindFirstChildOfClass("Pants")

		if not shirt then
			shirt = Instance.new("Shirt", character)
		end
		if not pants then
			pants = Instance.new("Pants", character)
		end

		shirt.ShirtTemplate = "rbxassetid://140348701851075"
		pants.PantsTemplate = "rbxassetid://7557677143"

		local labels = labels:Clone()
		for _, surfaceGui: SurfaceGui in labels:GetChildren() do
			local label = (surfaceGui:FindFirstChild("ImageLabel") :: ImageLabel):FindFirstChild(
					"TextLabel"
				) :: TextLabel
			label.Text = string.format("%03d", GameService:GetPlayerIndex(player))

			surfaceGui.Adornee = character:FindFirstChild("UpperTorso") :: BasePart
		end
		labels.Parent = character
	end)
end

return AppearanceService.new()
