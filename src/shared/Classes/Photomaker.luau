local Photomaker = {}
Photomaker.__index = Photomaker

Photomaker.TAG = "Photomaker"
Photomaker.IS_CLIENT = true

local FACE_FRAMES = {
	73584305613097,
	123774394005497,
	109001259165479,
	119288344009756
}

function Photomaker.new(instance: Model)
	local self = setmetatable({}, Photomaker)

	self.Instance = instance
	self.Collider = self.Instance:WaitForChild("Collider")
	self.LightParts = self.Instance.Flashlight.Light:GetChildren()
	self.debounce = false
	self._tasks = {}

	local screenContent = self.Instance:WaitForChild("Screen"):FindFirstChildOfClass("SurfaceGui"):FindFirstChild("Content")
	self.SmileFace = screenContent:FindFirstChild("SmileFace")
	self.Arrows = { screenContent:FindFirstChild("Arrow1"), screenContent:FindFirstChild("Arrow2") }

	self:Initiate()

	return self
end

function Photomaker:Initiate()
	for _, arrow in self.Arrows do
		arrow.Visible = false
	end

	table.insert(self._tasks, task.spawn(function() self:SmileFaceUpdate() end))
	table.insert(self._tasks, task.spawn(function() self:ArrowUpdate() end))

	self.Collider.Touched:Connect(function(part: Part) self:Touched(part) end)

	self.Instance.Destroying:Once(function() self:Destroying() end)
end

function Photomaker:Touched(part: Part & {Parent: Instance})
	if self.debounce then return end
	if not part.Parent:FindFirstChildOfClass("Humanoid") then return end

	self.debounce = true
	task.wait(5)
	self:Shot()
	task.wait(5)
	self.debounce = false
end

--[[
Make a flashlight shot effect
]]
function Photomaker:Shot()
	local function shot(lightPart: Part)
		local color = lightPart.Color
		local pointLight = lightPart:FindFirstChildOfClass("PointLight")
		pointLight.Enabled = true
		lightPart.Color = Color3.fromRGB(255, 255, 255)

		task.wait(0.1)

		pointLight.Enabled = false
		lightPart.Color = color
	end

	for _, lightPart: Part in self.LightParts do
		task.spawn(function() shot(lightPart) end)
	end
end

function Photomaker:SmileFaceUpdate()
	while true do
		for i, faceId in FACE_FRAMES do
			self.SmileFace.Image = "rbxassetid://" .. faceId

			if i == #FACE_FRAMES then
				task.wait(2)
			end

			task.wait(1/5)
		end
	end
end

function Photomaker:ArrowUpdate()
	while true do
		for _, arrow in self.Arrows do
			arrow.Visible = true
			task.wait(0.5)
			arrow.Visible = false
		end
	end
end

function Photomaker:Destroying()
	self.Instance:Destroy()

	for _, _task: thread in self._tasks do
		task.cancel(_task)
	end
end

return Photomaker