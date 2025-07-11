local speaker_ids = require(script.Parent.speaker_ids)
local types = require(script.Parent.types)

type dialogue_tree = types.dialogue_tree

-- These personalities may not be evident in every single piece of dialogue, but they are the intended general vibe of the character.
local player_focused = speaker_ids.player_1
local player_smart = speaker_ids.player_2
local player_observant = speaker_ids.player_3
local player_brainrot = speaker_ids.player_4

local Barky = speaker_ids.Barky
local Ronald = speaker_ids.Ronald

return {
	-- When the game starts.
	start = {
		dialogue_id = "start",
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
		dialogue_id = "house",
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
		response_speaker_id = player_smart,
		responses = {
			{
				button_text = "Knock.",
				response_text = "We can knock on his door."
			},
			{
				button_text = "Sit around.",
				response_text = "I guess we just have to sit around for him to come out."
				-- Leads to: boring
			}
		}
	} :: dialogue_tree,

	boring = {
		dialogue_id = "boring",
		texts = {
			speaker_id = player_observant,
			text = "This is so boring."
		}
	} :: dialogue_tree,

	-- When Barky arrives, regardless of how.
	meet_barky = {
		dialogue_id = "Barky",
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
		dialogue_id = "road",
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
		response_speaker_id = player_brainrot,
		responses = {
			{
				button_text = "Jump down.",
				response_text = "Let us jump down!"
			},
			{
				button_text = "Sit around.",
				response_text = "I guess we just have to sit around until... uh... we teleport down?",
				next = {
					dialogue_id = "teleport",
					texts = {
						{
							speaker_id = player_smart,
							text = "What... That makes no sense."
						}
						-- Then: they teleport down.
					}
				} :: dialogue_tree?
			}
		}
	} :: dialogue_tree,

	-- If players teleport down.
	teleport = {
		dialogue_id = "did teleport",
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
	} :: dialogue_tree,

	-- When players reach the valley, regardless of how.
	valley = {
		dialogue_id = "valley",
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
			},
			{
				speaker_id = player_observant,
				text = "Is nobody going to comment on this floating road?"
			}
		}
	} :: dialogue_tree,

	-- When players reach the store.
	store = {
		dialogue_id = "store",
		texts = {
			{
				speaker_id = player_observant,
				text = "This is an... interesting store. But anyway, I am still wondering what that sign said."
			},
			{
				speaker_id = Ronald,
				text = "Hiya folks! Hope you can find what you need."
			},
			{
				speaker_id = Barky,
				text = "Alright guys, here is the shopping list:\n- 5 Shopping List\n- 3 Shopping Lists\n- 3 Shopping Lists\n- 3"
			},
			{
				speaker_id = player_focused,
				text = "Yoo! The store barely has enough left in stock."
			},
			{
				speaker_id = player_smart,
				text = "Dude... why are we buying shopping lists?"
			},
			{
				speaker_id = player_focused,
				text = "Lock in. I really want to go on this trip."
			}
		}
	} :: dialogue_tree,

	buy = {
		dialogue_id = "buy",
		texts = {
			{
				speaker_id = Barky,
				text = "Okay Ronald, we are ready to checkout."
			},
			{
				speaker_id = Ronald,
				text = "I AM SICK OF WORKING HERE. THE LAST TIME I GOT A VACATION WAS"
			},
			{
				speaker_id = Ronald,
				text = "Great! That will cost $9,0.1"
			},
			{
				speaker_id = Barky,
				text = "Uh oh guys... I only have ${barky_cash}."
			}
		},
		response_speaker_id = player_focused,
		responses = {
			{
				button_text = "Run away.",
				response_text = "Let's run!",
				next = {
					dialogue_id = "shoplift",
					texts = {
						{
							speaker_id = Ronald,
							text = "Hey! Where are you guys going?!"
						}
					}
				} :: dialogue_tree?
			},
			{
				button_text = "Admit defeat.",
				response_text = "Ok gg.",
				next = {
					dialogue_id = "sale",
					texts = {
						{
							speaker_id = Ronald,
							text = "By the way, we are having a 100% off sale today."
						}
					}
				} :: dialogue_tree?
			}
		}
	} :: dialogue_tree
}