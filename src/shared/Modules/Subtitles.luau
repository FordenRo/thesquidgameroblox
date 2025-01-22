local TweenService = game:GetService("TweenService")

local Subtitles = {}
Subtitles.__index = Subtitles

local player = game.Players.LocalPlayer

type Subtitle = {
	start: number,
	text: string,
}

function createTextLabel(text: string)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.TextTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.AnchorPoint = Vector2.new(0.5, 1)
	label.Position = UDim2.new(0.5, 0, 1, -20)
	label.TextSize = 18
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Size = UDim2.fromScale(1, 0)
	label.BackgroundTransparency = 1
	label.Parent = player.PlayerGui.Subtitles.Content

	TweenService:Create(label, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()

	task.delay(math.max(#text * 0.03, 1), function()
		TweenService
			:Create(label, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
			:Play()
	end)
end

function Subtitles.new(SRT: string)
	local self = setmetatable({}, Subtitles)

	self.SRT = SRT

	self.parsedSubtitles = {} :: { Subtitle }
	for start, text in self.SRT:gmatch("(%d%d:%d%d:%d%d,%d%d%d)\n(.-)\n?\n") do
		local startTime = tonumber(start:sub(1, 2)) :: number * 3600
			+ tonumber(start:sub(4, 5)) :: number * 60
			+ tonumber(start:sub(7, 8)) :: number
			+ tonumber(start:sub(10)) :: number / 1000
		text = text:gsub("\n", " ")
		table.insert(self.parsedSubtitles, { start = startTime, text = text })
	end

	return self
end

function Subtitles:Start()
	local startTime = time()
	table.sort(self.parsedSubtitles, function(a, b)
		return a.start < b.start
	end)
	-- task.spawn(function()
	-- 	while true do
	-- 		task.wait(0.5)
	-- 		print(string.format("%.1f", time() - startTime))
	-- 	end
	-- end)
	self.task = task.spawn(function()
		for _, subtitle: Subtitle in self.parsedSubtitles do
			task.wait(subtitle.start - (time() - startTime))

			createTextLabel(subtitle.text)
		end
	end)
end

function Subtitles:Stop()
	if self.task then
		task.cancel(self.task)
	end
end

return Subtitles
