local ReplicatedStorage = game:GetService("ReplicatedStorage")

local table_join = require(ReplicatedStorage.client.table_join)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function(props: {
	native: {[any]: any}?,
	children: React.ReactNode?
})
	return e("TextLabel", table_join({
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		FontFace = Font.fromName("Montserrat"),
		TextSize = 28
	}, props.native), props.children)
end