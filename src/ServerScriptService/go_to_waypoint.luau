local bots = require(script.Parent.bots)

local waypoints = workspace.Map.Waypoints

local function go_to_waypoint(dialogue_id: string): ()
	local waypoint = waypoints:FindFirstChild(dialogue_id)
	if waypoint == nil then
		return
	end

	bots.all_move_to(waypoint.Position)
end

return go_to_waypoint