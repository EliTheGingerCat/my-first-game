local ReplicatedStorage = game:GetService("ReplicatedStorage")

local get_speaker_name = require(ReplicatedStorage.client.get_speaker_name)
local useClock = require(ReplicatedStorage.client.react_hooks.useClock)
local types = require(ReplicatedStorage.client.types)
local background = require(script.Parent.background)
local scale = require(script.Parent.scale)
local text = require(script.Parent.text)
local React = require(ReplicatedStorage.vendor.ReactLua.React)

local e = React.createElement
local DIALOGUE_SPEED = 20

local function get_graphemes(text: string): number
	local count = 0
	for _ in utf8.graphemes(text) do
		count += 1
	end
	return count
end

return function(props: {
	dialogue_tree: types.dialogue_tree,
	dialogue_finished: () -> ()
})
	local currentNode, setCurrentNode = React.useState(props.dialogue_tree)
	local currentFrame, setCurrentFrame = React.useState(1)
	local lastChanged, setLastChanged = React.useState(0)
	local clockBinding = useClock()

	React.useEffect(function()
		setCurrentNode(props.dialogue_tree)
	end, {props.dialogue_tree})

	React.useEffect(function()
		setCurrentFrame(1)
	end, {currentNode})

	React.useEffect(function()
		setLastChanged(clockBinding:getValue())
	end, {currentNode, currentFrame} :: {unknown})

	local function get_text(): string
		if currentFrame > 0 then
			return currentNode.texts[currentFrame].text
		else
			return assert(currentNode.responses)[math.abs(currentFrame)].response_text
		end
	end

	local function get_speaker_id(): number
		if currentFrame > 0 then
			return currentNode.texts[currentFrame].speaker_id
		else
			return assert(currentNode.responses)[math.abs(currentFrame)].speaker_id
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
			Text = clockBinding:map(function(clock: number)
				local progress = (clock - lastChanged) * DIALOGUE_SPEED / get_graphemes(get_text())
				return
					if progress < 1 then "click to skip"
					elseif currentFrame < #currentNode.texts then "click to advance"
					else ""
			end),
			TextStrokeTransparency = 0.5,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextSize = 25,
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.fromOffset(0, -30),
			TextXAlignment = Enum.TextXAlignment.Right
		}}),
		Button = e("TextButton", {
			BackgroundTransparency = 1,
			Text = "",
			Size = UDim2.fromScale(1, 1),
			[React.Event.Activated] = function()
				setLastChanged(-math.huge)
			end
		}),
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
						return math.min((clock - lastChanged) * DIALOGUE_SPEED, get_graphemes(get_text()))
					end),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true
				}})
			})
		})
	})
end