local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = require(ReplicatedStorage.constants)
local get_graphemes = require(ReplicatedStorage.get_graphemes)
local dialogue_info = require(script.Parent.dialogue_info)

local ids = {1, 2, 3, 4}

local function player_added(player: Player): ()
	if #ids == 0 then
		return
	end

	local id = table.remove(ids, math.random(1, #ids))

	player:SetAttribute("speaker_id", id)
end

for _, player in Players:GetPlayers() do
	player_added(player)
end

Players.PlayerAdded:Connect(player_added)

ReplicatedStorage.remotes.choose_response.OnServerEvent:Connect(function(player, response_index: unknown)
	if typeof(response_index) ~= "number" then
		return
	end

	local current_node = dialogue_info.active_node

	if current_node == nil then
		return
	end

	if current_node.response_speaker_id ~= player:GetAttribute("speaker_id") then
		return
	end

	local response = assert(current_node.responses)[response_index]
	if response == nil then
		return
	end

	dialogue_info.active_node = response.next

	ReplicatedStorage.remotes.response_chosen:FireAllClients(response_index)

	if response.response_id then
		task.delay(get_graphemes(response.response_text) / constants.DIALOGUE_SPEED + 2, function()
			if dialogue_info.active_node ~= response.next then
				return
			end
			dialogue_info.response_ended:Fire(response.response_id)
		end)
	end
end)
