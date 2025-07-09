local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local types = require(ReplicatedStorage.types)
local dialogue = require(script.Parent.dialogue)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function()
	local currentDialogue: types.dialogue_tree?, setCurrentDialogue = React.useState(nil :: types.dialogue_tree?)
	local dialogueId, setDialogueId = React.useState("")

	React.useEffect(function()
		local connection = ReplicatedStorage.remotes.start_dialogue.OnClientEvent:Connect(function(dialogue_name: string, id: string)
			setCurrentDialogue(all_dialogue[dialogue_name])
			setDialogueId(id)
		end)
		return function()
			connection:Disconnect()
		end
	end, {})

	return e("ScreenGui", {
		ResetOnSpawn = false
	}, {
		Dialogue = currentDialogue ~= nil and e(dialogue, {
			dialogue_tree = currentDialogue,
			dialogue_id = dialogueId,
			dialogue_finished = function()
				setCurrentDialogue(nil)
			end
		})
	})
end
