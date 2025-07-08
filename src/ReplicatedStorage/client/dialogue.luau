local speaker_ids = require(script.Parent.speaker_ids)
local types = require(script.Parent.types)

type dialogue_tree = types.dialogue_tree

-- These personalities may not be evident in every single piece of dialogue, but they are the intended general vibe of the character.
local player_focused = speaker_ids.player_1
local player_smart = speaker_ids.player_2
local player_observant = speaker_ids.player_3
local player_brainrot = speaker_ids.player_4

local Barky = speaker_ids.Barky

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
	} :: dialogue_tree,

	-- When Barky arrives, regardless of how.
	meet_barky = {
		texts = {
			{
				speaker_id = Barky,
				text = "Hey guys!"
			},
			{
				speaker_id = player_observant,
				text = "Your door is broken."
			},
			{
				speaker_id = Barky,
				text = "Yeah, I will fix it soon. Anyway, we need to pick up a few items at the store before our trip."
			}
		}
	} :: dialogue_tree,

	road = {
		texts = {
			{
				speaker_id = player_observant,
				text = "Dang... the road is broken."
			},
			{
				speaker_id = player_brainrot,
				text = "I guess this is Where the Sidewalk Ends."
			},
			{
				speaker_id = player_observant,
				text = "Hey, I love that book!"
			},
			{
				speaker_id = player_focused,
				text = "Dude... it looks like this is where the WORLD ends. Why is there a massive cliff?!"
			},
			{
				speaker_id = player_focused,
				text = "How are we going to get down?"
			}
		},
		responses = {
			{
				speaker_id = player_brainrot,
				text = "Let us jump down!"
			},
			{
				speaker_id = player_brainrot,
				text = "I guess we just have to sit around until... uh... we teleport down?",
				next = {
					texts = {
						{
							speaker_id = player_smart,
							text = "What... That makes no sense."
						}
						-- Then: they teleport down.
					}
				} :: dialogue_tree
			}
		}
	},

	-- If players teleport down.
	teleport = {
		texts = {
			{
				speaker_id = player_smart,
				text = "bro what"
			},
			{
				speaker_id = player_brainrot,
				text = "I told you 💔"
			}
		}
	},

	-- When players reach the valley, regardless of how.
	valley = {
		texts = {
			{
				speaker_id = player_observant,
				text = "What does this sign say?"
			},
			{
				speaker_id = player_focused,
				text = "Where does Barky live again?"
			},
			{
				speaker_id = player_smart,
				text = "I think he lives- wait, you already asked that. Also, right now we are going to the store..."
			},
			{
				speaker_id = player_focused,
				text = "Oh, yeah. Where is the store again?"
			},
			{
				speaker_id = player_smart,
				text = "I think it is right around the corner."
			}
		}
	}
}