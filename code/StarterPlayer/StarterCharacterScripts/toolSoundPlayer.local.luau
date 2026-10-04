repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
repeat task.wait() until plr.Character


task.wait(0.5)

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end


local playSound = game.ReplicatedStorage.gameplayEvents.playSound

local equip
local unequip

plr.Character.ChildAdded:Connect(function(tool)
	
	if tool:IsA("Tool") == false then 
		return 
	end -- If its not a tool then just return bruh
	
	local equipSound = tool:FindFirstChild("equipSound", 1)
	if equipSound then
				
		equip = equipSound

		playSound:FireServer(equipSound, tool, 10, 20) -- Plays the sound on the server

	end

	local unequipSound = tool:FindFirstChild("unequipSound", 1)
	if unequipSound then

		unequip = unequipSound
		
		playSound:FireServer(equipSound, tool, 10, 20) -- Plays the sound on the server

	end
	

end)


plr.Character.ChildRemoved:Connect(function(tool)
	
	if tool:IsA("Tool") == false then return end -- If its not a tool then just return bruh
	
	if unequip then
		playSound:FireServer(unequip, tool, 10, 20) -- Plays the sound on the server
	end
	
	equip = nil
	unequip = nil
	
end)
