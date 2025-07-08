local speaker_ids = require("./speaker_ids")
local types = require("./types")

type dialogue_tree = types.dialogue_tree

return {
	-- When the game starts.
	start = {
		texts = {
			{
				speaker_id = speaker_ids.player_1,
				text = "Where does Barky live again?"
			},
			{
				speaker_id = speaker_ids.player_2,
				text = "I think he lives just around the corner."
			}
		},
	} :: dialogue_tree,

	-- When the players reach the house.
	house = {
		texts = {
			{
				speaker_id = speaker_ids.player_4,
				text = "Ts house is goofy 🥀"
			},
			{
				speaker_id = speaker_ids.player_3,
				text = "Hey, look. The door is broken!"
			},
			{
				speaker_id = speaker_ids.player_1,
				text = "How are we going to get in?"
			}
		},
		responses = {
			{
				speaker_id = speaker_ids.player_2,
				response_text = "We can knock on his door."
			},
			{
				speaker_id = speaker_ids.player_2,
				response_text = "I guess we just have to sit around for him to come out."
				-- Leads to: boring
			}
		}
	} :: dialogue_tree,

	boring = {
		texts = {
			speaker_id = speaker_ids.player_3,
			text = "This is so boring."
		}
	} :: dialogue_tree
}