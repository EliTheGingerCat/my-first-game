local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local bots = require(script.Parent.bots)
local choose_response = require(script.Parent.choose_response)
local dialogue_info = require(script.Parent.dialogue_info)
local player_ids = require(script.Parent.player_ids)

PhysicsService:RegisterCollisionGroup("Character")
PhysicsService:CollisionGroupSetCollidable("Character", "Character", false)

local function on_character_add(character: Model): ()
	for _, part in character:GetChildren() do
		if part:IsA("BasePart") then
			part.CollisionGroup = "Character"
		end
	end
end

-- When a player joins, they must take the place of a bot, since the game will always be filled to capacity, using bots if necessary.
local function on_player_add(player: Player): ()
	local id = bots.remove_random_character()
	player_ids.player_added(player, id)
	if player.Character then
		on_character_add(player.Character)
	end
	player.CharacterAdded:Connect(on_character_add)
end

-- Replace leaving players with bots.
local function on_player_removing(player: Player): ()
	local id = player_ids.player_removing(player)
	bots.add_character(id)
end

for _, player in Players:GetPlayers() do
	on_player_add(player)
end
Players.PlayerAdded:Connect(on_player_add)
Players.PlayerRemoving:Connect(on_player_removing)
bots.bot_added:Connect(on_character_add)

-- Start off with everyone as a bot.
local PLAYABLE_CHARACTER_IDS = {1, 2, 3, 4}
for _, id in PLAYABLE_CHARACTER_IDS do
	bots.add_character(id)
end

dialogue_info.dialogue_ended:Connect(function()
	local node = dialogue_info.active_node
	assert(node, "Active node is missing.")

	local responder_id = node.response_speaker_id
	if responder_id == nil then
		return
	end

	local index = table.find(bots.ids, responder_id)
	if index == nil then
		return
	end
	-- Guaranteed that the responder is a bot.

	task.wait(3)

	local responses = node.responses
	assert(responses, "Node responses of dialogue are missing.")

	local response_index = math.random(1, #responses)

	choose_response(responder_id, response_index)
end)