local ids = {1, 2, 3, 4}

local function add_player(player: Player): ()
	if #ids == 0 then
		return
	end

	local id = table.remove(ids, math.random(1, #ids))

	player:SetAttribute("speaker_id", id)
end

local function remove_player(player: Player): ()
	table.insert(ids, player:GetAttribute("speaker_id") :: number)
end

return table.freeze({
	add_player = add_player,
	remove_player = remove_player
})