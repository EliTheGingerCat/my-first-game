local Players = game:GetService("Players")

local bots = require(script.Parent.bots)

local function teleport_everyone(position: Vector3): ()
	for _, player in Players:GetPlayers() do
		if player.Character then
			player.Character:PivotTo(CFrame.new(position))
		end
	end
	bots.all_teleport(position)
end

return teleport_everyone