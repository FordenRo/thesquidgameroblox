local NumberDisplay = {}
NumberDisplay.__index = NumberDisplay

local DIGIT_TABLE = {
	[0] = { 1, 2, 3, 5, 6, 7 },
	[1] = { 3, 6 },
	[2] = { 1, 3, 4, 5, 7 },
	[3] = { 1, 3, 4, 6, 7 },
	[4] = { 2, 3, 4, 6 },
	[5] = { 1, 2, 4, 6, 7 },
	[6] = { 1, 2, 4, 5, 6, 7 },
	[7] = { 1, 3, 6 },
	[8] = { 1, 2, 3, 4, 5, 6, 7 },
	[9] = { 1, 2, 3, 4, 6, 7 },
}

function NumberDisplay.new(instance: Model)
	local self = setmetatable({}, NumberDisplay)

	self.Instance = instance
	self.Color = (self.Instance:FindFirstChild("D_1") :: Part).Color
	self.LightColor = Color3.fromHex("#a84949")

	return self
end

function NumberDisplay:ShowDigit(digit: number)
	self:Clear()

	for _, idx in DIGIT_TABLE[digit] do
		self.Instance:FindFirstChild("D_" .. idx).Color = self.LightColor
	end
end

function NumberDisplay:Clear()
	for _, segment in self.Instance:GetChildren() do
		segment.Color = self.Color
	end
end

return NumberDisplay
