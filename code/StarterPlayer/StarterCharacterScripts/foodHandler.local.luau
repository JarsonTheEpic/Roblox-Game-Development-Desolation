repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end

local meleeStats = {
	["Kitchen knife"] = {"Kitchen knife"},
	Shiv = {"Shiv"},
	Fists = {"fists"}
}

local weapon
local meleeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.meleeEvent

plr.Character.ChildAdded:Connect(function(child)

	local melee = meleeStats[child.Name]
	if melee then
		weapon = child
	end

end)

plr.Character.ChildRemoved:Connect(function()
	
	weapon = nil
	
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
