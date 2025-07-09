local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local dialogue_state = require(script.Parent.dialogue_state)

local detections = workspace.Map.Detections

local function play_dialogue(name: string): ()
	dialogue_state.active_node = all_dialogue[name]
	ReplicatedStorage.remotes.start_dialogue:FireAllClients(name, HttpService:GenerateGUID(false))
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
