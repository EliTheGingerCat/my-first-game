local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = require(ReplicatedStorage.constants)
local dialogue_info = require(script.Parent.dialogue_info)
local get_graphemes = require(ReplicatedStorage.get_graphemes)
local types = require(ReplicatedStorage.types)

type dialogue_tree = types.dialogue_tree

local function prepare_dialogue_ended(node: dialogue_tree): ()
	local grapheme_count = 0
	local text_count = 0
	for _, text in assert(dialogue_info.active_node).texts do
		grapheme_count += get_graphemes(text.text)
		text_count += 1
	end
	task.delay(grapheme_count / constants.DIALOGUE_SPEED + text_count * 2, function()
		if dialogue_info.active_node ~= node then
			return
		end
		dialogue_info.dialogue_ended:Fire(assert(node.dialogue_id))
	end)
end

return prepare_dialogue_ended