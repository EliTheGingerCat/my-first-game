local ReplicatedStorage = game:GetService("ReplicatedStorage")

local useClock = require(ReplicatedStorage.client.react_hooks.useClock)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

local clock_start: number
local FADE_TIME = 1 -- Time to fade from 1 to 0.
local FADE_TIME_TOTAL = FADE_TIME * 2 -- Time to fade from 1 to 0 and back again.

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
				if clock_start == nil then
					clock_start = clock
				end

				local elapsed = clock - clock_start

				if elapsed <= FADE_TIME then
					return 1 - (elapsed / FADE_TIME)
				elseif elapsed < FADE_TIME_TOTAL then
					return (elapsed - FADE_TIME) / FADE_TIME
				else
					return 1
				end
			end)
		})
	})
end
