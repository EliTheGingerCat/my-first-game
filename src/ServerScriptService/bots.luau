local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local bot_names = require(ReplicatedStorage.bots_names)
local Signal = require(ReplicatedStorage.vendor.Signal)
local bot_models = ServerStorage.bots

local humanoids = {} :: {Humanoid}
local ids = {} :: {number}
local last_position = workspace.Map.SpawnLocation.Position + Vector3.new(0, 1.5, 0)
local models = {} :: {Model}
local path = PathfindingService:CreatePath()
local threads = {} :: {thread}
local bot_added: Signal.Signal<Model> = Signal.new()

local function add_character(id: number): ()
	local index = table.find(ids, id)
	assert(index == nil, `Id "{id}" is already taken.`)
	table.insert(ids, id)
	local name = bot_names[id] :: string?
	assert(name ~= nil, `Id "{id}" is invalid.`)
	local model = bot_models:FindFirstChild(name) :: Model?
	assert(model ~= nil, `Backup character "{name}" was not found in storage.`)
	local clone = model:Clone()
	table.insert(models, clone)
	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	assert(humanoid ~= nil, `Humanoid not found in model "{name}".`)
	table.insert(humanoids, humanoid)
	local animate = ServerStorage.Animate:Clone()
	animate.Parent = clone
	clone:PivotTo(CFrame.new(last_position))
	clone.Parent = workspace
	bot_added:Fire(clone)
end

local function remove_character(id: number): ()
	local name = bot_names[id] :: string?
	assert(name ~= nil, `Id "{id}" is invalid.`)
	local model = workspace:FindFirstChild(name) :: Model?
	assert(model ~= nil, `Backup character "{name}" was not found in Workspace.`)
	local index_model = table.find(models, model)
	assert(index_model ~= nil, `Model "{name}" was not found in array of models.`)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	assert(humanoid ~= nil, `Humanoid not found in model "{name}".`)
	local index_humanoid = table.find(humanoids, humanoid)
	assert(index_humanoid ~= nil, `Humanoid of bot "{name}" was not found in array of humanoids.`)
	table.remove(humanoids, index_humanoid)
	model:Destroy()
end

--[=[
	@return number -- Id of bot removed.
]=]
local function remove_oldest_character(): number
	local first = table.remove(ids, 1) :: number?
	assert(first ~= nil, "No bots exist right now.")
	remove_character(first)
	return first
end

local function cleanup(): ()
	for _, thread in threads do
		task.cancel(thread)
	end
	table.clear(threads)
end

local function follow_waypoints(humanoid: Humanoid, waypoints: {PathWaypoint}): ()
	for _, waypoint in waypoints do
		if waypoint.Action == Enum.PathWaypointAction.Jump then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		elseif waypoint.Action == Enum.PathWaypointAction.Walk then
			humanoid:MoveTo(waypoint.Position)
			humanoid.MoveToFinished:Wait()
		end
	end
end

local function all_teleport(position: Vector3): ()
	for _, model in models do
		model:PivotTo(CFrame.new(position))
	end
end

--[=[
	@return boolean -- Whether there was success.
]=]
local function try_pathfinding(position: Vector3): boolean
	cleanup()

	local success, errorMessage = pcall(path.ComputeAsync, path, last_position, position)
	if not success then
		print(`Failed to compute path: {errorMessage}`)
		return false
	end

	last_position = position

	if path.Status ~= Enum.PathStatus.Success then
		print(`Path creation was unsuccessful: {path.Status.Name}`)
		return false
	end

	local waypoints = path:GetWaypoints()

	for _, humanoid in humanoids do
		local thread = task.spawn(follow_waypoints, humanoid, waypoints)
		table.insert(threads, thread)
	end

	return true
end

local function all_move_to(position: Vector3): ()
	local correct_position = position
	local success = try_pathfinding(correct_position)
	if not success then
		all_teleport(correct_position)
	end
end

return table.freeze({
	add_character = add_character,
	ids = ids,
	all_move_to = all_move_to,
	all_teleport = all_teleport,
	remove_oldest_character = remove_oldest_character,
	bot_added = bot_added
})