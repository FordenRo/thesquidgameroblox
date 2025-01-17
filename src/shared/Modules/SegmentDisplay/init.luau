local SegmentDisplay = {}
SegmentDisplay.__index = SegmentDisplay

local NumberDisplay = require(script.NumberDisplay)

function SegmentDisplay.new(instance: Model, lightColor: Color3?)
	local self = setmetatable({}, SegmentDisplay)

	self.Instance = instance
	self.LightColor = lightColor or Color3.fromHex("#a84949")

	self.NumberDisplays = {}
	for _, numberDisplay in self.Instance.NumberDisplays:GetChildren() do
		local display = NumberDisplay.new(numberDisplay)
		display.LightColor = self.LightColor
		self.NumberDisplays[tonumber(numberDisplay.Name)] = display
	end

	self.Dots = self.Instance.Dots:GetChildren()
	self.DotColor = self.Dots[1].Color
	self.DotEnabled = false

	return self
end

function SegmentDisplay:ShowNumber(number: number)
	local letters = string.split(tostring(number), "")
	for i = 4, 1, -1 do
		local letter = letters[i]
		if letter then
			self.NumberDisplays[i]:ShowDigit(tonumber(letter))
		else
			self.NumberDisplays[i]:ShowDigit(0)
		end
	end
end

function SegmentDisplay:ShowTime(time: number)
	local seconds = math.floor(time) % 60
	local minutes = math.floor(time / 60) % 60

	self.NumberDisplays[1]:ShowDigit(math.floor(minutes / 10))
	self.NumberDisplays[2]:ShowDigit(minutes % 10)
	self.NumberDisplays[3]:ShowDigit(math.floor(seconds / 10))
	self.NumberDisplays[4]:ShowDigit(seconds % 10)
end

function SegmentDisplay:ToggleDots(state: boolean?)
	if state == nil then
		self.DotEnabled = not self.DotEnabled
	else
		self.DotEnabled = state
	end

	for _, dot in self.Dots do
		dot.Color = if self.DotEnabled then self.LightColor else self.DotColor
	end
end

function SegmentDisplay:Clear()
	if self.DotEnabled then
		self:ToggleDots(false)
	end

	for _, numberDisplay in self.NumberDisplays do
		numberDisplay:Clear()
	end
end

return SegmentDisplay