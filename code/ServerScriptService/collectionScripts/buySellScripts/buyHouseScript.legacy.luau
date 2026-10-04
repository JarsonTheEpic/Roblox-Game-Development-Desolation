local cs = game:GetService("CollectionService")
local plrTip = game:WaitForChild("ReplicatedStorage").plrTipsEvent
local ss = game:WaitForChild("ServerStorage")

for i, buyPart in pairs (cs:GetTagged("buyHouse")) do
	
	buyPart.buyHousePrompt.ObjectText = buyPart.Price.Value.. " Crons"
	
	buyPart.buyHousePrompt.Triggered:Connect(function(plr)
		
		local Crons = plr.leaderstats.Crons
		local price = buyPart.Price.Value
		local plrProperties = plr.ownedProperties.Value
		local maxProperties = plr.maxOwnedProperties.Value
		
		if plrProperties >= maxProperties then
			plrTip:FireClient(plr, "You can only have a maximum of ".. maxProperties.. " properties!", 3)
			return
		end
		
		if Crons.Value <= price then
			plrTip:FireClient(plr, "You don't have enough money", 3)
		else -- Purchase successful
			plrTip:FireClient(plr, "Successfully rented!", 3)
			
			Crons.Value -= price
			local newKey = ss.Tools.Other.Key:Clone()
			newKey.linkedDoor.Value = buyPart.Parent
			newKey.Parent = plr.Backpack
			
			plr.ownedProperties.Value += 1
			
			buyPart.SurfaceGui.TextLabel.Text = "Rent out"
			buyPart.buyHousePrompt.Enabled = false
		end
		
	end)
	
end
