local cs = game:GetService("CollectionService")

local plrTips = game:WaitForChild("ReplicatedStorage").plrTipsEvent


local sellPointInfos = {
	pawnShop1 = { -- First is item name, price value
		{Name = "Wires", cashValue = 35},
		{Name = "Diamond ring", cashValue = 180},
		{Name = "Makarov", cashValue = 60},
		{Name = "GCP45", cashValue = 80},
		{Name = "CAP10", cashValue = 110},
		{Name = "Book", cashValue = 25},
		{Name = "USB", cashValue = 120},
	}
}


for i, sellPoint in pairs(cs:GetTagged("sellPoint")) do
	
	local sellPrompt = sellPoint.promptPart.sellPrompt
	
	sellPrompt.Triggered:Connect(function(plr)
		
		local char = plr.Character
		
		local tool = plr.Character:FindFirstChildOfClass("Tool")
		if tool then
			
			local success = false
			
			for i, child in sellPointInfos[sellPoint.Name] do
				
				if child.Name == tool.Name then -- Successfully sold item
					
					plr.leaderstats.Crons.Value += child.cashValue
					plrTips:FireClient(plr, "You got paid ".. child.cashValue.. " For your "..tool.Name.. "!" , 3)
					tool:Destroy()
					
					success = true
					break
					
				end
				
			end
			
			if success == false then
				plrTips:FireClient(plr, "We don't buy that here!", 3)
			end
			
		else
			
			plrTips:FireClient(plr, "Equip a tool to sell it!", 3)
			
		end
		
	end)
	
end
