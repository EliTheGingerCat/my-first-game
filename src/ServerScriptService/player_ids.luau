local function add_player(player: Player, id: number): ()
	player:SetAttribute("speaker_id", id)
end

--[=[
	@return number -- The id that the player had.
]=]
local function player_removing(player: Player): number
	local id = player:GetAttribute("speaker_id") :: number?
	assert(id, `Player "{player.Name}" was missing a speaker id.`)
	return id
end

return table.freeze({
	add_player = add_player,
	player_removing = player_removing
})