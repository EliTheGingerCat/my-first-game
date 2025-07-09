local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dialogue_state = require(script.Parent.dialogue_state)

local ids = {1, 2, 3, 4}

local function player_added(player: Player): ()
	if #ids == 0 then
		return
	end

	local id = math.random(1, #ids)
	table.remove(ids, id)

	player:SetAttribute("speaker_id", id)
end

for _, player in Players:GetPlayers() do
	player_added(player)
end

Players.PlayerAdded:Connect(player_added)

ReplicatedStorage.remotes.choose_response.OnServerEvent:Connect(function(player, response_id: number)
	if typeof(response_id) ~= "number" then
		return
	end

	local current_node = dialogue_state.active_node

	if current_node == nil then
		return
	end

	if current_node.response_speaker_id ~= player:GetAttribute("speaker_id") then
		return
	end

	local response = assert(current_node.responses)[response_id]
	if response == nil then
		return
	end

	dialogue_state.active_node = response.next

	ReplicatedStorage.remotes.response_chosen:FireAllClients(response_id)
end)
