local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local b_c_names = require(ReplicatedStorage.backup_characters)
local b_c_models = ServerStorage.backup_characters

local ids = {}

local function add_character(id: number): ()
	local index = table.find(ids, id)
	assert(index == nil, `Id "{id}" is already taken.`)
	table.insert(ids, id)
	local name = b_c_names[id] :: string?
	assert(name ~= nil, `Id "{id}" is invalid.`)
	local model = b_c_models:FindFirstChild(name) :: Model?
	assert(model ~= nil, `Backup character "{name}" was not found in storage.`)
	model:Clone().Parent = workspace
end

local function remove_character(id: number): ()
	local name = b_c_names[id] :: string?
	assert(name ~= nil, `Id "{id}" is invalid.`)
	local model = workspace:FindFirstChild(name) :: Model?
	assert(model ~= nil, `Backup character "{name}" was not found in Workspace.`)
	model:Destroy()
end

--[=[
	@return number -- Id of bot removed.
]=]
local function remove_oldest_character(): number
	local first = table.remove(ids, 1) :: number?
	assert(first, "No bots exist right now.")
	remove_character(first)
	return first
end

return table.freeze({
	add_character = add_character,
	ids = ids,
	remove_oldest_character = remove_oldest_character
})