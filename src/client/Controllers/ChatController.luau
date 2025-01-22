local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local ChatController = {}
ChatController.__index = ChatController

local getPlayerIndex = ReplicatedStorage.Functions.GetPlayerIndex

function ChatController.new()
	local self = setmetatable({}, ChatController)

	TextChatService.OnIncomingMessage = function(message)
		return self:IncomingMessage(message)
	end

	return self
end

function ChatController:IncomingMessage(message: TextChatMessage)
	local properties = Instance.new("TextChatMessageProperties")
	if not message.TextSource then
		properties.Text = `[Game] {message.Text}`
		return properties
	end

	local player = game.Players:GetPlayerByUserId(message.TextSource.UserId)
	local index = getPlayerIndex:InvokeServer(player)
	properties.PrefixText = string.format('<font color="#aaaaaa">[%03d]</font> %s :', index, player.DisplayName)

	return properties
end

return ChatController.new()
