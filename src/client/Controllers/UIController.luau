local StarterGui = game:GetService("StarterGui")

local UIController = {}
UIController.__index = UIController

function UIController.new()
	local self = setmetatable({}, UIController)

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

	task.spawn(function()
		repeat
			local success = pcall(function()
				StarterGui:SetCore("ResetButtonCallback", false)
			end)

			task.wait()
		until success
	end)

	return self
end

return UIController.new()
