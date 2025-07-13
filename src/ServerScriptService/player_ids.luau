local function player_added(player: Player, id: number): ()
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
	player_added = player_added,
	player_removing = player_removing
})