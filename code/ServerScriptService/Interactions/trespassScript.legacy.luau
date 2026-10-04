local cs = game:GetService("CollectionService")
local players = game:GetService("Players")

local rs = game:WaitForChild("ReplicatedStorage")

local plrTips = rs:WaitForChild("plrTipsEvent")

for i, zone in pairs(cs:GetTagged("trespassZone")) do
	

	zone.Touched:Connect(function(hit)
		
		local trespassBounty = zone:GetAttribute("trespassBounty")

		if hit.Parent:FindFirstChild("Humanoid") then

			local plr = players:GetPlayerFromCharacter(hit.Parent)
			
			if plr then
				
				if zone:GetAttribute("needsPassport") == true then -- If the zone needs a passport to enter, the checks for if the player is a citizen
					
					local isCitizen = plr.isCitizen
					if isCitizen.Value then return end -- The player is not trespassing if they are a citizen
					
				end
				
				local char = hit.Parent

				if char:FindFirstChild(zone.Name) then return end -- Adds the zone name as a flag to the character, so they can't trespass twice
				
				local flag = Instance.new("BoolValue")
				flag.Value = true
				flag.Name = zone.Name
				flag.Parent = char
				
				plrTips:FireClient(plr, "You are trespassing!", 3, Color3.new(1, 0.3, 0.1))
				plr.playerstats.Bounty.Value += trespassBounty
				
			end

		end
		
	end)
	
end