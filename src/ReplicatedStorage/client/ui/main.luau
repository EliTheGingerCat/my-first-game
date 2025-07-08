local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.client.types)
local dialogue = require(script.Parent.dialogue)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function()
	local currentDialogue: types.dialogue_tree?, setCurrentDialogue = React.useState(nil :: types.dialogue_tree?)

	React.useEffect(function()
		workspace.Map.Part.ProximityPrompt.Triggered:Connect(function()
			setCurrentDialogue({
				texts = {{text = "Hello Bro, what are you doing?", speaker_id = 1}},
				responses = {
					{response_text = "Nothing.", speaker_id = 2}
				}
			})
		end)
	end, {})

	return e("ScreenGui", {
		ResetOnSpawn = false
	}, {
		Dialogue = currentDialogue ~= nil and e(dialogue, {
			dialogue_tree = currentDialogue,
			dialogue_finished = function()
				
			end
		})
	})
end
