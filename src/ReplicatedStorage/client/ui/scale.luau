local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.vendor.ReactLua.React)

local camera = workspace.CurrentCamera
local e = React.createElement

return function()
	local scale, setScale = React.useState(1)

	React.useEffect(function()
		local function update_scale()
			local viewport_size = camera.ViewportSize

			setScale(1 / math.max(
				1920 / viewport_size.X,
				1080 / viewport_size.Y
			))
		end

		update_scale()

		local connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(update_scale)
		
		return function()
			connection:Disconnect()
		end
	end, {})

	return e("UIScale", {
		Scale = scale
	})
end