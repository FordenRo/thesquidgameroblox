local PlayerCountText = {}
PlayerCountText.__index = PlayerCountText

function PlayerCountText.new(instance: Frame)
	local self = setmetatable({}, PlayerCountText)

	self.Instance = instance

	return self
end

function PlayerCountText:SetPlayerCount(count: number)
	local letters = string.split(tostring(count), "")
	for i = 3, 1, -1 do
		local letter = letters[i]
		local label = self.Instance:FindFirstChild("D_" .. i)

		if not letter then
			label.Visible = false
			continue
		end

		label.TextLabel.Text = letter
		label.Visible = true
	end
end

return PlayerCountText
