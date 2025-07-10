local Players = game:GetService("Players")

local bot_ids = require(script.Parent.bot_ids)
local player_ids = require(script.Parent.player_ids)

-- Start off with everyone as a bot.
local PLAYABLE_CHARACTER_IDS = {1, 2, 3, 4}
for _, id in PLAYABLE_CHARACTER_IDS do
	bot_ids.add_character(id)
end

-- When a player joins, they must take the place of a bot, since the game will always be filled to capacity, using bots if necessary.
local function on_player_add(player: Player): ()
	local id = bot_ids.remove_oldest_character()
	player_ids.add_player(player, id)
end

-- Replace leaving players with bots.
local function on_player_removing(player: Player): ()
	local id = player_ids.player_removing(player)
	bot_ids.add_character(id)
end

for _, player in Players:GetPlayers() do
	on_player_add(player)
end

Players.PlayerAdded:Connect(on_player_add)

Players.PlayerRemoving:Connect(on_player_removing)