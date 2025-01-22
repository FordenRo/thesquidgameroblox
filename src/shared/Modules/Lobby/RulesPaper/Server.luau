local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RulesPaperServer = {}
RulesPaperServer.__index = RulesPaperServer

local paperRE = ReplicatedStorage.Remotes.RulesPaperRE

local createPoint = require(script.Parent.createPoint)

function RulesPaperServer.new(instance: Part)
	local self = setmetatable({}, RulesPaperServer)

	self.Instance = instance
	self.Drawable = self.Instance:FindFirstChildOfClass("SurfaceGui"):FindFirstChild("Drawable") :: CanvasGroup
	self.Owner = nil :: Player?

	paperRE.OnServerEvent:Connect(function(...)
		self:Event(...)
	end)

	return self
end

function RulesPaperServer:SetOwner(player: Player)
	self.Owner = player
	paperRE:FireClient(player, "Owner")
end

function RulesPaperServer:Event(player: Player, action: string, ...)
	if action == "draw" then
		if self.Owner ~= player then
			return
		end

		local points = ...
		for _, point: Vector2 in points do
			createPoint(point.X, point.Y, self.Drawable)
		end
	end
end

return RulesPaperServer
