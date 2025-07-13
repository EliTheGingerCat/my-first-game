-- Keep this in while the game is unfinished.

local dialogue_info = require(script.Parent.dialogue_info)

local function fire_response(id: string)
	task.delay(5, dialogue_info.response_ended.Fire, dialogue_info.response_ended, id)
end

local last_dialogue: string = nil

-- last_dialogue = "boring"
-- fire_response("knock")

return {
	last_dialogue = last_dialogue,
	hardcoded_responses = {}
}