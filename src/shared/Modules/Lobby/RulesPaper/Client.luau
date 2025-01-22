local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RulesPaperClient = {}
RulesPaperClient.__index = RulesPaperClient

local paperRE = ReplicatedStorage.Remotes.RulesPaperRE

local createPoint = require(script.Parent.createPoint)

function RulesPaperClient.new(instance: Part)
	local self = setmetatable({}, RulesPaperClient)

	self.Instance = instance
	self.Drawable = self.Instance:FindFirstChildOfClass("SurfaceGui"):FindFirstChild("Drawable") :: CanvasGroup
	self.IsOwner = false
	self.IsDrawing = false
	self.cons = {} :: { RBXScriptConnection }
	self.newPoints = {}

	paperRE.OnClientEvent:Connect(function(...)
		self:Event(...)
	end)

	-- testing purposes
	table.insert(
		self.cons,
		self.Drawable.InputBegan:Connect(function(input)
			self:InputBegan(input)
		end)
	)
	table.insert(
		self.cons,
		self.Drawable.InputChanged:Connect(function(input)
			self:InputChanged(input)
		end)
	)
	table.insert(
		self.cons,
		self.Drawable.InputEnded:Connect(function(input)
			self:InputEnded(input)
		end)
	)

	return self
end

function RulesPaperClient:Event(action: string, ...)
	if action == "Owner" then
		self.IsOwner = true
	elseif action == "CanDraw" then
		local canDraw = ...
		if canDraw then
			table.insert(
				self.cons,
				self.Drawable.InputBegan:Connect(function(input)
					self:InputBegan(input)
				end)
			)
			table.insert(
				self.cons,
				self.Drawable.InputChanged:Connect(function(input)
					self:InputChanged(input)
				end)
			)
			table.insert(
				self.cons,
				self.Drawable.InputEnded:Connect(function(input)
					self:InputEnded(input)
				end)
			)
		else
			for _, con in self.cons do
				con:Disconnect()
			end
		end
	end
end

function RulesPaperClient:InputBegan(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		self.IsDrawing = true
		self.origin = input.Position
	end
end

function RulesPaperClient:InputChanged(input: InputObject)
	if not self.IsDrawing then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local x = input.Position.X - self.Drawable.AbsolutePosition.X
		local y = input.Position.Y - self.Drawable.AbsolutePosition.Y + self.Drawable.AbsoluteSize.Y

		createPoint(x, y, self.Drawable)
		table.insert(self.newPoints, Vector2.new(x, y))
	end
end

function RulesPaperClient:InputEnded(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		self.IsDrawing = false
		paperRE:FireServer("draw", self.newPoints)
		table.clear(self.newPoints)
	end
end

function RulesPaperClient:StartDraw() end

return RulesPaperClient
