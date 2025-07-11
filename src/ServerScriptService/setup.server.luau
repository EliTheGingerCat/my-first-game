local ReplicatedStorage = game:GetService("ReplicatedStorage")

local choose_response = require(script.Parent.choose_response)

ReplicatedStorage.remotes.choose_response.OnServerEvent:Connect(function(player, response_index: unknown)
	local speaker_id = player:GetAttribute("speaker_id") :: number?
	assert(speaker_id, `Player "{player.Name}" has no speaker id.`)
	choose_response(speaker_id, response_index)
end)