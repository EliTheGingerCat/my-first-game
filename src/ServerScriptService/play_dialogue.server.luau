local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local constants = require(ReplicatedStorage.constants)
local get_graphemes = require(ReplicatedStorage.get_graphemes)
local go_to_waypoint = require(script.Parent.go_to_waypoint)
local dialogue_info = require(script.Parent.dialogue_info)

local detections = workspace.Map.Detections

local function play_dialogue(name: string): ()
	dialogue_info.active_node = all_dialogue[name]
	ReplicatedStorage.remotes.start_dialogue:FireAllClients(name, HttpService:GenerateGUID(false))

	local node = assert(dialogue_info.active_node)
	if node.dialogue_id then
		local grapheme_count = 0
		local text_count = 0
		for _, text in assert(dialogue_info.active_node).texts do
			grapheme_count += get_graphemes(text.text)
			text_count += 1
		end
		go_to_waypoint(node.dialogue_id)
		task.delay(grapheme_count / constants.DIALOGUE_SPEED + text_count * 2, function()
			if dialogue_info.active_node ~= node then
				return
			end
			dialogue_info.dialogue_ended:Fire(assert(node.dialogue_id))
		end)
	end
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
