local speaker_ids = require("./speaker_ids")
local types = require("./types")

type dialogue_tree = types.dialogue_tree

-- These personalities may not be evident in every single piece of dialogue, but they are the intended general vibe of the character.
local player_focused = speaker_ids.player_1
local player_smart = speaker_ids.player_2
local player_observant = speaker_ids.player_3
local player_brainrot = speaker_ids.player_4

return {
	-- When the game starts.
	start = {
		texts = {
			{
				speaker_id = player_focused,
				text = "Where does Barky live again?"
			},
			{
				speaker_id = player_smart,
				text = "I think he lives just around the corner."
			}
		},
	} :: dialogue_tree,

	-- When the players reach the house.
	house = {
		texts = {
			{
				speaker_id = player_brainrot,
				text = "Ts house is goofy 🥀"
			},
			{
				speaker_id = player_observant,
				text = "Hey, look. The door is broken!"
			},
			{
				speaker_id = player_focused,
				text = "How are we going to get in?"
			}
		},
		responses = {
			{
				speaker_id = player_smart,
				response_text = "We can knock on his door."
			},
			{
				speaker_id = player_smart,
				response_text = "I guess we just have to sit around for him to come out."
				-- Leads to: boring
			}
		}
	} :: dialogue_tree,

	boring = {
		texts = {
			speaker_id = player_observant,
			text = "This is so boring."
		}
	} :: dialogue_tree
}