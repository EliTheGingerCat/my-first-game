local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local dialogue_state = require(script.Parent.dialogue_state)

return function(name: string): ()
	dialogue_state.active_node = all_dialogue[name]
	ReplicatedStorage.remotes.start_dialogue:FireAllClients(name, HttpService:GenerateGUID(false))
end
