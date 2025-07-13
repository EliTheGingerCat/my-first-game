-- Keep this in while the game is unfinished.

local dialogue_info = require(script.Parent.dialogue_info)
local go_to_waypoint = require(script.Parent.go_to_waypoint)

local DELAY = 5

local function fire_dialogue(id: string)
	task.delay(DELAY, dialogue_info.dialogue_ended.Fire, dialogue_info.dialogue_ended, id)
end

local function fire_response(id: string)
	task.delay(DELAY, dialogue_info.response_ended.Fire, dialogue_info.response_ended, id)
end

local function go(id: string): ()
	task.delay(DELAY, go_to_waypoint, id)
end

local last_dialogue: string = nil

-- last_dialogue = "store"
-- fire_dialogue()
-- fire_response()
-- go("store")

return {
	last_dialogue = last_dialogue,
	hardcoded_responses = {}
}