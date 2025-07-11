--> Verify that all dialogue ids are unique.

-- Place this in ReplicatedStorage.

-- require(game:GetService("ReplicatedStorage").ModuleScript)

local all_dialogue = require(script.Parent.all_dialogue)
local types = require(script.Parent.types)

type dialogue_tree = types.dialogue_tree

local dialogue = all_dialogue :: {[string]: dialogue_tree}
local ids = {}
local trees = {} :: {dialogue_tree}

for _, tree in dialogue do
	table.insert(trees, tree)
end

for _, tree in trees do
	if ids[tree.dialogue_id] then
		error(`Id "{tree.dialogue_id}" is already taken.`)
	end
	ids[tree.dialogue_id] = true

	if tree.responses ~= nil then
		for _, response in tree.responses do
			if response.next ~= nil then
				table.insert(trees, response.next)
			end
		end
	end
end

print("All good.")

return nil