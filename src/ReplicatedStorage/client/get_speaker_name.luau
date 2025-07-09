local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local speaker_ids = require(ReplicatedStorage.speaker_ids)

local name_to_id = speaker_ids :: {[string]: number}

local id_to_name = {}
for name, id in name_to_id do
	id_to_name[id] = name
end

return function(speaker_id: number): string
	local name = id_to_name[speaker_id]
	if speaker_id < 5 then
		for _, player in Players:GetPlayers() do
			if player:GetAttribute("speaker_id") == speaker_id then
				return player.Name
			end
		end
		return "Unknown"
	else
		return name
	end
end
