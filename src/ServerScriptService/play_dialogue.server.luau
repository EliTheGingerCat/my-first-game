local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local dialogue_info = require(script.Parent.dialogue_info)
local go_to_waypoint = require(script.Parent.go_to_waypoint)
local prepare_dialogue_ended = require(script.Parent.prepare_dialogue_ended)
local teleport_everyone = require(script.Parent.teleport_everyone)

local detections = workspace.Map.detections
local teleports = workspace.Map.teleports

local function play_dialogue(name: string): ()
	local node = all_dialogue[name]

	dialogue_info.active_node = node
	ReplicatedStorage.remotes.start_dialogue:FireAllClients(name, HttpService:GenerateGUID(false))

	prepare_dialogue_ended(node)
end

-- return true to disconnect
local function on_player_touch(part: BasePart, callback: () -> true?): ()
	local connection: RBXScriptConnection
	connection = part.Touched:Connect(function(hit)
		if Players:GetPlayerFromCharacter(hit.Parent) ~= nil then
			local do_disconnect = callback()
			if do_disconnect then
				connection:Disconnect()
			end
		end
	end)
end

play_dialogue("start")

local done_road = false
on_player_touch(detections.BarkyHouse, function()
	play_dialogue("house")
	done_road = true
	return true
end)

on_player_touch(detections.Road, function()
	if not done_road then
		return
	end

	play_dialogue("road")
	return true
end)

on_player_touch(detections.Valley, function()
	play_dialogue("valley")
	return true
end)

on_player_touch(detections.Store, function()
	play_dialogue("store")
	return true
end)

-- Where should the NPCs go when this dialogue finishes playing?
-- index = dialogue that finished
-- value = where to go
local next_waypoint = {
	start = "house",
	meet_barky = "road",
	-- road is hardcoded
	valley = "store"
}

dialogue_info.dialogue_ended:Connect(function(dialogue_id)
	local waypoint = next_waypoint[dialogue_id] :: string?
	if waypoint ~= nil then
		go_to_waypoint(waypoint)
	end
end)

dialogue_info.dialogue_ended:Connect(function(dialogue_id)
	if dialogue_id == "teleport" then
		teleport_everyone(teleports.valley.Position)
	elseif dialogue_id == "did teleport" then
		go_to_waypoint("valley")
	end
end)

dialogue_info.response_ended:Connect(function(response_id)
	if response_id == "jump" then
		go_to_waypoint("valley")
	end
end)