return function(x: number, y: number, parent: Instance)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(2, 2)
	frame.AnchorPoint = Vector2.one * 0.5
	frame.BackgroundColor3 = Color3.new()
	frame.BackgroundTransparency = 0.1
	frame.Position = UDim2.fromOffset(x, y)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.5)
	corner.Parent = frame

	frame.Parent = parent
	return frame
end
