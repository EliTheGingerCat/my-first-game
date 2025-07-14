local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local bot_names = require(ReplicatedStorage.bots_names)
local Signal = require(ReplicatedStorage.vendor.Signal)
local bot_models = ServerStorage.bots

type Signal<T...> = Signal.Signal<T...>

type character = {
	model: Model,
	humanoid: Humanoid
}
type link = {
	start: Vector3,
	stop: Vector3
}

local bot_added: Signal<Model> = Signal.new()
local characters = {} :: {character}
local ids = {} :: {number}
local last_position = workspace.Map.SpawnLocation.Position + Vector3.new(0, 1.5, 0)
local path = PathfindingService:CreatePath()
local threads = {} :: {thread}

local path_links = {} :: {[string]: link}
for index, link in workspace.Map.links:GetChildren() do
	assert(link:IsA("PathfindingLink"), `Non PathfindingLink named "{link.Name}" found in links folder.`)
	path_links[link.Label] = {
		start = link.Attachment0.WorldCFrame.Position,
		stop = link.Attachment1.WorldCFrame.Position
	}
end

local function get_last_position(): Vector3
	return last_position
end

local function register_character(model: Model): ()
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	assert(humanoid ~= nil, `Humanoid not found in model "{model.Name}".`)
	table.insert(characters, {
		model = model,
		humanoid = humanoid
	})
	local animate = ServerStorage.Animate:Clone()
	animate.Parent = model
	bot_added:Fire(model)
end

local function add_bot(id: number): ()
	local index = table.find(ids, id)
	assert(index == nil, `Id "{id}" is already taken.`)
	table.insert(ids, id)
	local name = bot_names[id] :: string?
	assert(name ~= nil, `Id "{id}" is invalid.`)
	local model = bot_models:FindFirstChild(name) :: Model?
	assert(model ~= nil, `Backup character "{name}" was not found in storage.`)
	local clone = model:Clone()

	register_character(clone)
	
	clone:PivotTo(CFrame.new(last_position))
	clone.Parent = workspace
end

local function remove_bot(id: number): ()
	local name = bot_names[id] :: string?
	assert(name ~= nil, `Id "{id}" is invalid.`)
	local model = workspace:FindFirstChild(name) :: Model?
	assert(model ~= nil, `Backup character "{name}" was not found in Workspace.`)

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	assert(humanoid ~= nil, `Humanoid not found in model "{name}".`)

	local index_found: number
	for index, character in characters do
		if character.model == model then
			assert(character.humanoid == humanoid, `Humanoid of "{name}" does not match with character in table.`)
			index_found = index
			break
		end
	end
	assert(index_found ~= nil, `Model "{name}" was not found in array of characters.`)
	table.remove(characters, index_found)
	
	model:Destroy()
end

--[=[
	@return number -- Id of bot removed.
]=]
local function remove_random_bot(): number
	local first = table.remove(ids, math.random(1, #ids)) :: number?
	assert(first ~= nil, "No bots exist right now.")
	remove_bot(first)
	return first
end

local function is_bot(id: number)
	return table.find(ids, id) ~= nil
end

local function cleanup(): ()
	for _, thread in threads do
		task.cancel(thread)
	end
	table.clear(threads)
end

local function jump(humanoid: Humanoid): ()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

local VERTICAL_RISE = Vector3.new(0, 1, 0)
local VERTICAL_RISE_HALF = VERTICAL_RISE / 2
local function follow_waypoints(model: Model, humanoid: Humanoid, waypoints: {PathWaypoint}): ()
	for _, waypoint in waypoints do
		if waypoint.Action == Enum.PathWaypointAction.Jump then
			jump(humanoid)
		elseif waypoint.Action == Enum.PathWaypointAction.Walk then
			humanoid:MoveTo(waypoint.Position)

			local stop: true?
			local connection = humanoid.MoveToFinished:Once(function()
				stop = true
			end)

			-- Iono if any of this actually helps. The stuttering is still there but at least they actually are guaranteed get to their destination. The stuttering also seems more consistent, so each stutter is the same length.
			local start = tick()
			while true do
				if stop then
					break
				end

				local now = tick()
				local elapsed = now - start
				if elapsed > 1 then
					connection:Disconnect()
					model:PivotTo(CFrame.new(waypoint.Position))
					break
				end

				task.wait()
			end
		else
			-- Custom
			-- This is so scuffed. At least this actually works though. Trying to cooperate with PathfindingService might never work.
			local link = path_links[waypoint.Label]
			local direct_path = link.stop - link.start

			local quarter_plane = (direct_path) /4
			local quarter_1 = link.start + quarter_plane   + VERTICAL_RISE_HALF
			local quarter_2 = link.start + quarter_plane*2 + VERTICAL_RISE
			local quarter_3 = link.start + quarter_plane*3 + VERTICAL_RISE_HALF
			local quarter_4 = link.stop

			local without_y = Vector3.new(direct_path.X, 0, direct_path.Z)
			local facing = CFrame.lookAt(Vector3.zero, without_y)

			task.wait(0.1)
			model:PivotTo(CFrame.new(quarter_1) * facing)
			task.wait(0.1)
			model:PivotTo(CFrame.new(quarter_2) * facing)
			task.wait(0.1)
			model:PivotTo(CFrame.new(quarter_3) * facing)
			task.wait(0.1)
			model:PivotTo(CFrame.new(quarter_4) * facing)
			task.wait(0.1)
		end
	end
end

local function all_teleport(position: Vector3): ()
	for _, character in characters do
		character.model:PivotTo(CFrame.new(position))
	end
end

--[=[
	@return boolean -- Whether there was success.
]=]
local function try_pathfinding(position: Vector3): boolean
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

	for _, character in characters do
		print("going to:", position)
		local thread = task.spawn(follow_waypoints, character.model, character.humanoid, waypoints)
		table.insert(threads, thread)
		print("total threads:", #threads)
	end

	return true
end

local function all_move(position: Vector3): ()
	cleanup()
	local success = try_pathfinding(position)
	if not success then
		all_teleport(position)
	end
end

return table.freeze({
	add_bot = add_bot,
	all_move = all_move,
	all_teleport = all_teleport,
	bot_added = bot_added,
	get_last_position = get_last_position,
	is_bot = is_bot,
	register_character = register_character,
	remove_random_bot = remove_random_bot
})