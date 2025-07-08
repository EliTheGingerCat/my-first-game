local Players = game:GetService("Players")

local speaker_ids = require(script.Parent.speaker_ids)

local name_to_id = speaker_ids :: {[string]: number}

local id_to_name = {}
for name, id in name_to_id do
	id_to_name[id] = name
end

return function(speaker_id: number): string
	local name = id_to_name[speaker_id]
	local player_id = string.match(name, "^player_(%d)$")
	if player_id ~= nil then
		local players = Players:GetPlayers()
		local player: Player? = Players:GetPlayers()[player_id]
		if player == nil then
			return players[math.random(1, #players)].Name
		else
			return player.Name
		end
	else
		return name
	end
end
