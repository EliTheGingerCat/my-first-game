local ReplicatedStorage = game:GetService("ReplicatedStorage")

local useClock = require(ReplicatedStorage.client.react_hooks.useClock)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function()
	local clockBinding = useClock()

	return e("ScreenGui", {
		ScreenInsets = Enum.ScreenInsets.None,
		ResetOnSpawn = false,
	}, {
		Background = e("Frame", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = clockBinding:map(function(clock: number)
				
			end)
		})
	})
end
