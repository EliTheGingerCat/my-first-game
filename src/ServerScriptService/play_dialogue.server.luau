local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local bots = require(script.Parent.bots)
local dialogue_info = require(script.Parent.dialogue_info)
local go_to_waypoint = require(script.Parent.go_to_waypoint)
local objective = require(script.Parent.objective)
local prepare_dialogue_ended = require(script.Parent.prepare_dialogue_ended)
local teleport_everyone = require(script.Parent.teleport_everyone)
local testing_data = require(script.Parent.testing_data)

local barriers = workspace.Map.barriers
local detections = workspace.Map.detections
local teleports = workspace.Map.teleports

local last_dialogue = testing_data.last_dialogue

local function play_dialogue(name: string): ()
	local node = all_dialogue[name]

	dialogue_info.active_node = node
	ReplicatedStorage.remotes.start_dialogue:FireAllClients(name, HttpService:GenerateGUID(false))

	prepare_dialogue_ended(node)
end

-- return true to disconnect
local function on_player_touch(part: BasePart, callback: () -> true?): ()
	local connection: RBXScriptConnection
	connection = part.Touched:Connect(function(hit)
		if Players:GetPlayerFromCharacter(hit.Parent) ~= nil then
			local do_disconnect = callback()
			if do_disconnect then
				connection:Disconnect()
			end
		end
	end)
end

if last_dialogue == nil then
	task.wait(3)
	play_dialogue("start")
end

on_player_touch(detections.BarkyHouse, function()
	if last_dialogue ~= "start" then
		return
	end

	play_dialogue("house")
	return true
end)

local function meet_barky(): ()
	workspace.Barky:PivotTo(CFrame.new(teleports.barky.Position))
	bots.register_character(workspace.Barky)
	play_dialogue("meet_barky")
end

on_player_touch(detections.Road, function()
	if last_dialogue ~= "meet_barky" then
		return
	end

	play_dialogue("road")
	return true
end)

local function valley_teleport(): ()
	teleport_everyone(teleports.valley.Position)
	task.wait(1)
	play_dialogue("teleport")
end

local valley_ready = false
local function valley_done(): ()
	barriers.valley:Destroy()
	go_to_waypoint("valley")
	valley_ready = true
end

local function leave_store(): ()
	go_to_waypoint("train")
end

local TRAIN_SPEED = 20
local train = workspace.Map.Train
local function play_final_cutscene(): ()
	ReplicatedStorage.remotes.game_ended:FireAllClients()
	task.wait(4)
	for _, character in workspace:GetChildren() do
		if character:IsA("Model") and character.PrimaryPart and character.Name ~= "Ronald" then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid == nil then
				continue
			end

			humanoid.WalkSpeed = 0
			character:PivotTo(train.Teleport.CFrame)
		end
	end

	local connection
	connection = RunService.Heartbeat:Connect(function(delta_time)
		if train.PrimaryPart == nil then
			connection:Disconnect()
			return
		end
		train:PivotTo(train:GetPivot() - Vector3.xAxis * TRAIN_SPEED * delta_time)
		if train.PrimaryPart.Position.Y < -190 then
			connection:Disconnect()
			local parts = {}
			for _, descendant in train:GetDescendants() do
				if descendant:IsA("WeldConstraint") then
					descendant:Destroy()
				elseif descendant:IsA("BasePart") then
					table.insert(parts, descendant)
				end
			end
			for _, part in parts do
				local explosion = Instance.new("Explosion")
				explosion.Position = part.Position
				explosion.Parent = workspace
			end
		end
	end)
end

on_player_touch(detections.Valley, function()
	if not valley_ready then
		return
	end

	play_dialogue("valley")
	return true
end)

on_player_touch(detections.Store, function()
	if last_dialogue ~= "valley" then
		return
	end

	play_dialogue("store")
	return true
end)

objective.shopping_completed:Connect(function()
	play_dialogue("buy")
end)

on_player_touch(detections.Train, function()
	if last_dialogue ~= "buy" then
		return
	end

	play_dialogue("train")
	return true
end)

-- Where should the NPCs go when this dialogue finishes playing?
-- index = dialogue that finished
-- value = where to go
local next_waypoint = {
	start = "house",
	meet_barky = "road",
	-- road is hardcoded
	valley = "store"
}

dialogue_info.dialogue_ended:Connect(function(dialogue_id)
	local waypoint = next_waypoint[dialogue_id] :: string?
	if waypoint ~= nil then
		go_to_waypoint(waypoint)
	end

	last_dialogue = dialogue_id
end)

dialogue_info.dialogue_ended:Connect(function(dialogue_id)
	if dialogue_id == "teleport" then
		valley_teleport()
	elseif dialogue_id == "did teleport" then
		valley_done()
	elseif dialogue_id == "valley" then
		barriers.store:Destroy()
	elseif dialogue_id == "store" then
		objective.set_objective(objective.get_shopping_text())
	elseif dialogue_id == "buy" then
		objective.set_objective("")
	elseif dialogue_id == "sale" then
		task.spawn(leave_store)
		play_dialogue("go_to_train")
	elseif dialogue_id == "shoplift" then
		play_dialogue("go_to_train")
	elseif dialogue_id == "train" then
		play_final_cutscene()
	end
end)

dialogue_info.response_ended:Connect(function(response_id)
	if response_id == "knock" then
		meet_barky()
	elseif response_id == "wait" then
		task.wait(5)
		play_dialogue("boring")
		task.wait(5)
		meet_barky()
	elseif response_id == "jump" then
		valley_done()
	elseif response_id == "run" then
		leave_store()
	end
end)