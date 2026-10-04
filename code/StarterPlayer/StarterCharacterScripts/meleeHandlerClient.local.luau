repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end

local meleeStats = {
	["Kitchen knife"] = {"Kitchen knife"},
	Shiv = {"Shiv"},
	Fists = {"Fists"},
	Fireaxe = {"Fireaxe"},
	Bayonet = {"Bayonet"}
}

local weapon
local meleeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.meleeEvent
local updateSpeed = game:WaitForChild("ReplicatedStorage").gameplayEvents.updateSpeedEvent

local idleTrack = nil

-- Mobile controls
local meleeButton = plr.PlayerGui.mobileControls.meleeGui.meleeButton


function updateInput()
	local lastInput = UIS:GetLastInputType()
	if lastInput == Enum.UserInputType.Focus then return end -- ignore if the player focuses on the app
	plr.PlayerGui.mobileControls.meleeGui.Enabled = lastInput == Enum.UserInputType.Touch -- makes the frame visible if the user touched the screen
end


updateInput()
UIS.LastInputTypeChanged:Connect(updateInput)

plr.Character.ChildAdded:Connect(function(child)

	local melee = meleeStats[child.Name]
	if melee then
		weapon = child
		
		if weapon:FindFirstChild("Idle") then
			idleTrack = plr.Character.Humanoid.Animator:LoadAnimation(weapon.Idle)
			idleTrack:Play()
		end
		
		meleeButton.Visible = true -- Enables the melee button after equipping a melee
		
		--updateSpeed:FireServer(child, true)
	end

end)

plr.Character.ChildRemoved:Connect(function(child)
	
	weapon = nil
	
	meleeButton.Visible = false -- Enables the melee button after equipping a melee
	
	if idleTrack ~= nil then
		idleTrack:Stop()
	end
	
	if child:IsA("Tool") == true then
		--updateSpeed:FireServer(child, false)
	end
	
end)
	
UIS.InputBegan:Connect(function(I, E)
	if E then return end
	if weapon == nil then return end
	if I.UserInputType == Enum.UserInputType.MouseButton1 and weapon then
		if weapon:FindFirstChild("durability") then
			if weapon:FindFirstChild("durability", true).Value <= 0 then return end
		end
		meleeEvent:FireServer(weapon)
	end
	
end)

meleeButton.Activated:Connect(function()
	
	if weapon:FindFirstChild("durability") then
		if weapon:FindFirstChild("durability", true).Value <= 0 then return end
	end
	meleeEvent:FireServer(weapon)
	
end)