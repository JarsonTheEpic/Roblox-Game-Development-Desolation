local ss = game:WaitForChild("ServerStorage")
local rs = game:WaitForChild("ReplicatedStorage")
local cs = game:GetService("CollectionService")
local tws = game:GetService("TweenService")

local robberyReset = ss:WaitForChild("Events").robberyReset
local doorExplode = ss.Events.doorExplode
local plrTips = rs:WaitForChild("plrTipsEvent")


local BANK_ROBBERY_BOUNTY = 250


local function resetCash(cash, clickable, value) -- the clickCash instance, whether the cash can be grabbed or not
	
	if clickable then -- If the cash can be clicked again
		
		cash.Transparency = 0
		cash.CanCollide = true
		cash.CanQuery = true
		cash.ClickDetector.MaxActivationDistance = 10
		
		if value then -- If a new cash value is given
			cash:SetAttribute("cronsValue", value)
		end
		
	else
		
		cash.Transparency = 1
		cash.CanCollide = false
		cash.CanQuery = false
		cash.ClickDetector.MaxActivationDistance = 0 -- 0 max activation distance means that its impossible to click
		
		if value then -- If a new cash value is given
			cash:SetAttribute("cronsValue", value)
		end
		
	end
	
end



robberyReset.Event:Connect(function(robbery, resetTime)
	
	local available = robbery.robPart.available

	task.wait(resetTime)
	
	available.Value = true
	
	for i, child in pairs(robbery:GetDescendants()) do
		
		if child.Name == "clickCash" then -- Resets the cash to be clickable again
			
			print("resetting cash")
			resetCash(child, true, nil)
			
		end
		
	end
	
	if robbery.robPart:GetAttribute("robberyType") == "Register" then

		local cashDrawer = robbery.cashDrawer
		cashDrawer.Position = robbery.startPos.Position

	elseif robbery.robPart:GetAttribute("robberyType") == "Safe" then

		local hinge = robbery.hinge
		hinge.CFrame = robbery.startPos.CFrame

	end
	
end)


local function bankReset(vault, timer)
	
	local vaultRegion = vault.vaultRegion
	
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {vault}
	local parts = workspace:GetPartBoundsInBox(vaultRegion.CFrame, vaultRegion.Size, params)
	
	for i, part in pairs(parts) do -- Finds any character models in the vault and teleports them out
		
		local character = part:FindFirstAncestorOfClass("Model")
		if character and character:FindFirstChild("Humanoid") then -- If the model is actually a character
			
			local randomPoint = vault.teleportPoints:GetChildren()[math.random(1, #vault.teleportPoints:GetChildren())]
			character:MoveTo(randomPoint.Position)
			
		end
		
	end
	
	for i, plr in pairs(game.Players:GetChildren()) do -- Marks everyone as no longer robbing the bank
		
		plr.robbingBank.Value = false
		
	end
	
	vault.vaultDoor.available.Value = false
	
	task.wait(timer) -- Waits X seconds before allowing the bank to be robbed again

	vault.vaultDoor.available.Value = true
	
	for i, child in pairs(vault:GetChildren()) do -- Resets everything in the bank vault
		
		if child.Name == "safe" or child.Name == "cashRegister" then -- Resets the safes and the cash registers
			
			robberyReset:Fire(child, 0)
			
		elseif child.Name == "ClickCash" then
			
			resetCash(child, true, nil)
			
		end
		
	end
	
end


for i, region in pairs(cs:GetTagged("vaultRegion")) do
	local available = region.Parent.vaultDoor.available
	
	region.Touched:Connect(function(hit)
		if not available.Value then return end
		
		local char = hit:FindFirstAncestorOfClass("Model")
		if char == nil then return end
		
		local hum = char:FindFirstChild("Humanoid")
		if not hum then return end
		
		local plr = game.Players:GetPlayerFromCharacter(char)
		if plr then
			
			if plr.robbingBank.Value then return end
			
			plr.robbingBank.Value = true
			plr.playerstats.Bounty.Value += BANK_ROBBERY_BOUNTY
			
		end
		
	end)
	
end 


doorExplode.Event:Connect(function(door)

	if cs:HasTag(door, "singleDoor") then -- If the door is a single door
		local doorPart = door:FindFirstChild("door")
		print("exploding door")

		local lockOriginalState = door.lockDoorPart.lockDoorPrompt.Enabled -- Was the lock usable before the explosion
		door.lockDoorPart.lockDoorPrompt.Enabled = false
		doorPart.openDoorPrompt.Enabled = false

		local hinge = door.hinge
		local hingeOriginalCFrame = hinge.CFrame
		--print(hingeOriginalCFrame)

		hinge.Anchored = false

		task.wait(60) -- The door is disabled for X amount of time

		print("door respawned")
		door.lockDoorPart.lockDoorPrompt.Enabled = lockOriginalState
		hinge.CFrame = hingeOriginalCFrame
		hinge.Anchored = true
		doorPart.openDoorPrompt.Enabled = true
		
		local flag = door:FindFirstChild("destroyed") -- Deletes the flag
		if flag then 
			flag:Destroy()
		end

	elseif door.Name == "vaultDoor" then
		local vault = door.Parent
		
		local doorPart = door:FindFirstChild("vaultDoor")
		
		local hinge = door.hinge -- Opens the vault door
		local goal = {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(-110), 0)}
		local info = TweenInfo.new(2, Enum.EasingStyle.Sine)
		
		local open = tws:Create(hinge, info, goal)
		open:Play()
		
		doorPart.alarmSound:Play()
		task.wait(180) -- The door is disabled for X amount of time
		doorPart.alarmSound:Stop()
		
		goal = {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(110), 0)}
		local close = tws:Create(hinge, info, goal)
		close:Play()
		
		bankReset(vault, 600) -- It takes X amount of time for the vault to be able to be robbed again
	end

end)


for i, cash in pairs(cs:GetTagged("clickCash")) do
	
	local cd = cash.ClickDetector
	cd.MouseClick:Connect(function(plr)
		
		plr.leaderstats.Crons.Value += cash:GetAttribute("cronsValue")
		
		plrTips:FireClient(plr, "You took".. cash:GetAttribute("cronsValue").. "Crons!", 2)
		
		resetCash(cash, false, nil)
		
	end)
	
end

