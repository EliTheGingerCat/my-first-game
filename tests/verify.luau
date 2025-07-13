--> Verify that all dialogue ids are unique.

-- Place this in ReplicatedStorage.

-- require(game:GetService("ReplicatedStorage").ModuleScript)

local all_dialogue = require(script.Parent.all_dialogue)
local types = require(script.Parent.types)

type dialogue_tree = types.dialogue_tree

local diagnostics = {} :: {[string]: number}
local dialogue = all_dialogue :: {[string]: dialogue_tree}
local dialogue_ids = {} :: {[string]: true?}
local response_ids = {} :: {[string]: true?}
local trees = {} :: {dialogue_tree}

local function add(message: string)
	if diagnostics[message] then
		diagnostics[message] += 1
	else
		diagnostics[message] = 1
	end
end

local function is_empty(t: {[any]: any}): boolean
	return next(t) == nil
end

for _, tree in dialogue do
	table.insert(trees, tree)
end

for _, tree in trees do
	if dialogue_ids[tree.dialogue_id] then
		add(`Id "{tree.dialogue_id}" is already taken.`)
	end
	dialogue_ids[tree.dialogue_id] = true

	if tree.responses ~= nil then
		for _, response in tree.responses do
			if response.next ~= nil then
				table.insert(trees, response.next)

				if response_ids[response.response_id] then
					add(`Id "{response.response_id}" is already taken.`)
				end
			end
		end
	end
end

if not is_empty(diagnostics) then
	for message, count in diagnostics do
		print(`{message}\nCount: {count}`)
	end
	
	return nil
end

print("All good.")

return nil