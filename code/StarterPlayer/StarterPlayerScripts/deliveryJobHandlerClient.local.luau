local rs = game:GetService("ReplicatedStorage")
local cs = game:GetService("CollectionService")

local deliveryJobEvent = rs:WaitForChild("gameplayEvents").deliveryJobEvent

repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()


local function hidePrompts() -- Hides every single turn in point prompt before the player gets assigned the job
	for i, point in pairs(cs:GetTagged("turnInPoint")) do
		
		local box = plr.Backpack:FindFirstChild("Supply box") or plr.Character:FindFirstChild("Supply box") -- Checks if the player's job is assigned to this point
		if box then
			if box.toolStats.turnInPoint.Value == point then
				continue
			end
		end
		
		point.turnInPrompt.Enabled = false

	end
end



deliveryJobEvent.OnClientEvent:Connect(function(point, enable)

	point.turnInPrompt.Enabled = enable

end)


cs:GetInstanceAddedSignal("turnInPoint"):Connect(function() -- Whenever a turn in point is rendered, disable it (unless the player has a job assigned to it)
	
	hidePrompts()
	
end)