local bots = require(script.Parent.bots)

local waypoints = workspace.Map.waypoints

local function go_to_waypoint(name: string): ()
	local waypoint = waypoints:FindFirstChild(name)
	if waypoint == nil then
		return
	end

	bots.all_move_to(waypoint.Position)
end

return go_to_waypoint