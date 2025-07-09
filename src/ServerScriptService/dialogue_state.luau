local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.types)

return {
	active_node = nil :: types.dialogue_tree?
}