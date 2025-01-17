local PathfindingService = game:GetService("PathfindingService")

local NPC = {}
NPC.__index = NPC

function NPC.new(character: Model)
	local self = setmetatable({}, NPC)

	self.Character = character
	self.Humanoid = self.Character:WaitForChild("Humanoid")
	self.targetCFrame = self.Character.Target.CFrame
	self._walkToFinishedEvent = Instance.new("BindableEvent")
	self.WalkToFinished = self._walkToFinishedEvent.Event

	return self
end

function NPC:WalkTo(position: Vector3, speed: number?)
	if speed then
		self.Humanoid.WalkSpeed = speed
	end

	task.spawn(function()
		local animator = self.Humanoid.Animator :: Animator
		local path = PathfindingService:CreatePath({ AgentRadius = 3 })
		path:ComputeAsync(self.Character:GetPivot().Position, position)
		local waypoints = path:GetWaypoints()

		local animationTrack = animator:LoadAnimation(self.Character.Animate.walk.WalkAnim)
		animationTrack:Play(0.2)

		for _, waypoint in waypoints do
			self.Humanoid:MoveTo(waypoint.Position)
			self.Humanoid.MoveToFinished:Wait()
		end

		animationTrack:Stop(0.2)
		self._walkToFinishedEvent:Fire()
	end)
end

function NPC:LookAt(lookAt: Vector3, duration: number?)
	if not duration then
		duration = 1
	end

	local time = os.clock()
	local targetCFrame = CFrame.new(self.Character:GetPivot().Position, lookAt)

	task.spawn(function()
		repeat
			local alpha = (os.clock() - time) * duration
			self.Character:PivotTo(self.Character:GetPivot():Lerp(targetCFrame, alpha))
			task.wait()
		until alpha > 1
	end)
end

function NPC:GetPivot(): CFrame
	return self.Character:GetPivot()
end

function NPC:PivotTo(targetCFrame: CFrame)
	self.Character:PivotTo(targetCFrame)
end

return NPC