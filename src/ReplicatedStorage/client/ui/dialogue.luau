local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local get_speaker_name = require(ReplicatedStorage.client.get_speaker_name)
local useClock = require(ReplicatedStorage.client.react_hooks.useClock)
local constants = require(ReplicatedStorage.constants)
local get_graphemes = require(ReplicatedStorage.get_graphemes)
local types = require(ReplicatedStorage.types)
local background = require(script.Parent.background)
local scale = require(script.Parent.scale)
local text = require(script.Parent.text)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement

return function(props: {
	dialogue_tree: types.dialogue_tree,
	dialogue_id: string,
	dialogue_finished: () -> ()
})
	local currentNode, setCurrentNode = React.useState(props.dialogue_tree)
	local currentFrame, setCurrentFrame = React.useState(1)
	local isWaiting, setIsWaiting = React.useState(false)
	local lastChanged, setLastChanged = React.useState(0)
	local clockBinding = useClock()

	local function get_text(): string
		if currentFrame < 0 then
			return assert(currentNode.responses)[math.abs(currentFrame)].response_text
		else
			return currentNode.texts[currentFrame].text
		end
	end

	local function get_speaker_id(): number
		if currentFrame < 0 then
			return assert(currentNode.response_speaker_id)
		else
			return currentNode.texts[currentFrame].speaker_id
		end
	end

	React.useEffect(function()
		setCurrentNode(props.dialogue_tree)
	end, {props.dialogue_tree})

	React.useEffect(function()
		setCurrentFrame(1)
	end, {currentNode, props.dialogue_id} :: {unknown})

	React.useEffect(function()
		setLastChanged(clockBinding:getValue())
	end, {currentNode, currentFrame, props.dialogue_id} :: {unknown})

	React.useEffect(function()
		local connection = ReplicatedStorage.remotes.response_chosen.OnClientEvent:Connect(function(id)
			setCurrentFrame(-id)
		end)

		return function()
			connection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local elapsed = 0
		local total_time = get_graphemes(get_text()) / constants.DIALOGUE_SPEED + 2
		local connection
		connection = RunService.PostSimulation:Connect(function(delta_time)
			elapsed += delta_time
			if elapsed >= total_time then
				if currentFrame < #currentNode.texts and currentFrame > 0 then
					setCurrentFrame(currentFrame + 1)
				elseif currentFrame < 0 then
					assert(currentNode.responses)
					local next = currentNode.responses[math.abs(currentFrame)].next
					if next then
						setCurrentNode(next)
						setCurrentFrame(1)
					else
						props.dialogue_finished()
					end
				elseif currentNode.responses == nil or #currentNode.responses == 0 then
					props.dialogue_finished()
				else
					setIsWaiting(true)
				end
				connection:Disconnect()
			end
		end)

		return function()
			setIsWaiting(false)
			if connection and connection.Connected then
				connection:Disconnect()
			end
		end
	end, {lastChanged, currentFrame, currentNode, props.dialogue_id} :: {unknown})

	local response_buttons = {}

	if currentFrame == #currentNode.texts and currentNode.responses ~= nil and #currentNode.responses > 0 and isWaiting then
		for index, response in currentNode.responses do
			table.insert(response_buttons, e(background, {native = {
				Size = UDim2.fromOffset(295, 50)
			}}, {
				Text = e(text, {native = {
					Size = UDim2.fromScale(1, 1),
					Text = response.button_text
				}}),
				Button = e("TextButton", {
					BackgroundTransparency = 1,
					Text = "",
					Size = UDim2.fromScale(1, 1),
					[React.Event.Activated] = function()
						ReplicatedStorage.remotes.choose_response:FireServer(index)
					end
				})
			}))
		end
	end

	return e("Frame", {
		Size = UDim2.fromOffset(600, 200),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 0.95),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1
	}, {
		Scale = e(scale),
		NameText = e(text, {native = {
			Text = get_speaker_name(get_speaker_id()),
			TextStrokeTransparency = 0.5,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextSize = 35,
			Size = UDim2.new(1, 0, 0, 40),
			Position = UDim2.fromOffset(0, -40),
			TextXAlignment = Enum.TextXAlignment.Left
		}}),
		InfoText = e(text, {native = {
			Text =
				if currentFrame == #currentNode.texts and currentNode.response_speaker_id and isWaiting
				then `{get_speaker_name(currentNode.response_speaker_id)} is responding.`
				else "",
			TextStrokeTransparency = 0.5,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextSize = 25,
			Size = UDim2.new(1, 0, 0, 40),
			Position = UDim2.fromOffset(0, -40),
			TextXAlignment = Enum.TextXAlignment.Right
		}}),
		Contents = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			Layout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			Background = e(background, {native = {
				Size = UDim2.fromOffset(600, 200)
			}}, {
				Padding = e("UIPadding", {
					PaddingTop = UDim.new(0, 15),
					PaddingBottom = UDim.new(0, 15),
					PaddingLeft = UDim.new(0, 15),
					PaddingRight = UDim.new(0, 15),
				}),
				DialogueText = e(text, {native = {
					Size = UDim2.fromScale(1, 1),
					Text = get_text(),
					MaxVisibleGraphemes = clockBinding:map(function(clock: number)
						return math.min((clock - lastChanged) * constants.DIALOGUE_SPEED, get_graphemes(get_text()))
					end),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true
				}})
			}),
			Buttons = e("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromOffset(600, 0)
			}, {
				Layout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Wraps = true,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					VerticalFlex = Enum.UIFlexAlignment.SpaceBetween,
					Padding = UDim.new(0, 10)
				})
			}, response_buttons)
		})
	})
end