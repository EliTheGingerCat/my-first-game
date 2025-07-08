local ReplicatedStorage = game:GetService("ReplicatedStorage")

local table_join = require(ReplicatedStorage.client.table_join)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function(props: {
	native: {[any]: any}?,
	children: React.ReactNode?
})
	return e("Frame", table_join({
		BackgroundTransparency = 0.3,
		BackgroundColor3 = Color3.new(0, 0, 0)
	}, props.native), props.children)
end