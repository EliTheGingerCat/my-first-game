local bots = require(script.Parent.bots)

local waypoints = workspace.Map.waypoints

local function go_to_waypoint(name: string): ()
	local waypoint = waypoints:FindFirstChild(name)
	assert(waypoint, `Waypoint "{name}" was not found.`)

	bots.all_move(waypoint.Position)
end

return go_to_waypoint