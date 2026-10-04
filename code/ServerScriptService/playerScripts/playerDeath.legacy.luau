local players = game:GetService("Players")

local function resetHouses(plr)

	for i, tool in plr.Backpack:GetChildren() do

		if tool.Name == "Key" then

			local linkedDoor = tool.linkedDoor.Value
			local buyPart = linkedDoor.salePart
			buyPart.SurfaceGui.TextLabel.Text = "For rent"
			buyPart.buyHousePrompt.Enabled = true

		end

	end

end

players.PlayerAdded:Connect(function(plr)
	
	local char = plr.Character
	local hum = char.Humanoid
	
	hum.Died:Connect(function()
		local char = plr.Character
		if char:FindFirstChildOfClass("Tool") then
			char:FindFirstChildOfClass("Tool").Parent = plr.Backpack
		end
		
		plr.ownedProperties.Value = 0
		resetHouses(plr)
	end)
	
end)
