local Subtitles = {}
Subtitles.__index = Subtitles

local player = game.Players.LocalPlayer

type Subtitle = {
    start: number,
    finish: number,
    text: string
}

function Subtitles.new(SRT: string)
    local self = setmetatable({}, Subtitles)

    self.SRT = SRT

    self.ScreenGui = Instance.new("ScreenGui")
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Text = ""
    self.TextLabel.TextColor3 = Color3.new(1, 1, 1)
    self.TextLabel.AnchorPoint = Vector2.new(0.5, 1)
    self.TextLabel.Position = UDim2.new(0.5, 0, 1, -20)
    self.TextLabel.TextSize = 18
    self.TextLabel.Parent = self.ScreenGui
    self.TextLabel.AutomaticSize = Enum.AutomaticSize.XY
    self.TextLabel.Size = UDim2.new()
    self.TextLabel.BackgroundTransparency = 0.9
    self.TextLabel.BackgroundColor3 = Color3.new()
    self.ScreenGui.Parent = player.PlayerGui

    self.ScreenGui.Destroying:Once(function() self:Stop() end)

    self.parsedSubtitles = {}
    for index: string, start: string, finish: string, text: string in string.gmatch(self.SRT, "(%d+)\n(%d%d:%d%d:%d%d,%d%d%d) %-%-> (%d%d:%d%d:%d%d,%d%d%d)\n(.-)\n?\n") do
        local startTime = tonumber(start:sub(1, 2)) * 3600 + tonumber(start:sub(4, 5)) * 60 + tonumber(start:sub(7, 8)) + tonumber(start:sub(10)) / 1000
        local finishTime = tonumber(finish:sub(1, 2)) * 3600 + tonumber(finish:sub(4, 5)) * 60 + tonumber(finish:sub(7, 8)) + tonumber(finish:sub(10)) / 1000
        text = text:gsub("\n", " ")
        self.parsedSubtitles[tonumber(index)] = { start = startTime, finish = finishTime, text = text }
    end

    return self
end

function Subtitles:Start()
    local startTime = time()
    self.task = task.spawn(function()
        for _, subtitle: Subtitle in self.parsedSubtitles do
            task.wait(subtitle.start - (time() - startTime))

            for i = 1, #subtitle.text do
                self.TextLabel.Text = subtitle.text:sub(1, i)
                task.wait(1 / 50)
            end
        end
    end)
end

function Subtitles:Stop()
    task.cancel(self.task)
end

function Subtitles:Destroy()
    self:Stop()
    self.ScreenGui:Destroy()
end

return Subtitles