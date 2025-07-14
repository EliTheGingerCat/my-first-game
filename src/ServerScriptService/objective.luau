local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local dialogue_info = require(script.Parent.dialogue_info)
local Signal = require(ReplicatedStorage.vendor.Signal)

type Signal<T...> = Signal.Signal<T...>

local objective = ""
local shopping_lists = 0
local shopping_completed: Signal<> = Signal.new()

ReplicatedStorage.remotes.get_objective.OnServerInvoke = function()
	return objective
end

local ready = false

local function set_ready(): ()
	ready = true
end

local function set_objective(new: string): ()
	objective = new
	ReplicatedStorage.remotes.objective_changed:FireAllClients(new)
end

local function get_shopping_text(): string
	return `Collect shopping lists ({shopping_lists}/14).`
end

for _, shelf in workspace.Map.ValleyTown.Store:GetChildren() do
	if shelf.Name == "Shelf" then
		for _, list in shelf:GetChildren() do
			if list.Name == "ShoppingList" then
				assert(list:IsA("Model"), "Shopping list is not a model.")
				local prompt = Instance.new("ProximityPrompt")
				prompt.ObjectText = "Shopping list"
				prompt.ActionText = "Collect"
				prompt.HoldDuration = 1

				prompt.RequiresLineOfSight = false
				prompt.Parent = list.PrimaryPart
				prompt.Triggered:Connect(function()
					if not ready then
						return
					end
					
					if shopping_lists >= 14 or dialogue_info.active_node ~= all_dialogue.store then
						return
					end
					list:Destroy()
					shopping_lists += 1
					-- Bro sends the full text every time :sob::pray:.
					set_objective(get_shopping_text())
					if shopping_lists == 14 then
						shopping_completed:Fire()
					end
				end)
			end
		end
	end
end

return table.freeze({
	set_objective = set_objective,
	set_ready = set_ready,
	get_shopping_text = get_shopping_text,
	shopping_completed = shopping_completed
})