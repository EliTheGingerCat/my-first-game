local ReplicatedStorage = game:GetService("ReplicatedStorage")

local scale = require(script.Parent.scale)
local text = require(script.Parent.text)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function()
	local objective, setObjective = React.useState("")

	React.useEffect(function()
		local connection = ReplicatedStorage.remotes.objective_changed.OnClientEvent:Connect(function(new: string)
			setObjective(new)
		end)

		local thread = task.spawn(function()
			local current_objective = ReplicatedStorage.remotes.get_objective:InvokeServer()
			setObjective(current_objective)
		end)

		return function()
			connection:Disconnect()
			if thread then
				task.cancel(thread)
			end
		end
	end, {})

	return e(text, {native = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
		Position = UDim2.new(0.96, 0, 0.35, 0),
		AnchorPoint = Vector2.new(1, 0),
		TextSize = 28,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = if objective ~= "" then `Objective:\n{objective}` else ""
	}}, {
		Scale = e(scale)
	})
end