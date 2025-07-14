local ReplicatedStorage = game:GetService("ReplicatedStorage")

local all_dialogue = require(ReplicatedStorage.all_dialogue)
local types = require(ReplicatedStorage.types)
local dialogue = require(script.Parent.dialogue)
local end_screen = require(script.Parent.end_screen)
local objective = require(script.Parent.objective)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local local_camera = workspace.CurrentCamera

local cameras = workspace.Map.cameras

local e = React.createElement

local function gameover_camera(): ()
	local_camera.CameraType = Enum.CameraType.Scriptable
	local_camera.CFrame = cameras.one.CFrame
	task.wait(10)
	local_camera.CFrame = cameras.two.CFrame
end

return function()
	local currentDialogue: types.dialogue_tree?, setCurrentDialogue = React.useState(nil :: types.dialogue_tree?)
	local dialogueId, setDialogueId = React.useState("")

	local gameEnded, setGameEnded = React.useState(false)

	React.useEffect(function()
		local connection = ReplicatedStorage.remotes.start_dialogue.OnClientEvent:Connect(function(dialogue_name: string, id: string)
			setCurrentDialogue(all_dialogue[dialogue_name])
			setDialogueId(id)
		end)
		
		local thread = coroutine.create(gameover_camera)

		local connection2 = ReplicatedStorage.remotes.game_ended.OnClientEvent:Connect(function()
			setGameEnded(true)
			coroutine.resume(thread)
		end)
		return function()
			connection:Disconnect()
			connection2:Disconnect()
			coroutine.close(thread)
		end
	end, {})

	return e(React.Fragment, nil, {
		MainGui = e("ScreenGui", {
			ResetOnSpawn = false
		}, {
			Dialogue = currentDialogue ~= nil and e(dialogue, {
				dialogue_tree = currentDialogue,
				dialogue_id = dialogueId,
				dialogue_finished = function()
					setCurrentDialogue(nil)
				end
			}),
			Objective = e(objective)
		}),
		EndScreen = gameEnded and e(end_screen)
	})
end
