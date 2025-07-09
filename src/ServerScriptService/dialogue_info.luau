local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.types)
local Signal = require(ReplicatedStorage.vendor.Signal)

type Signal<T...> = Signal.Signal<T...>

return {
	active_node = nil :: types.dialogue_tree?,
	dialogue_ended = Signal.new() :: Signal<string>,
	response_ended = Signal.new() :: Signal<string>
}