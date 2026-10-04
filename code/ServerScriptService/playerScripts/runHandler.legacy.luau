local isRunningEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.runEvent
local updateSpeed = game:WaitForChild("ReplicatedStorage").gameplayEvents.updateSpeedEvent
local runSpeed = 22
local walkSpeed = 10

local tools = { -- Tools that affect walkspeed
	M4A1 = 0.1,
	["Scar-L"] = 0.15,
	AK47 = 0.15,
	["Kitchen knife"] = 0,
	Medkit = 0.2
}

isRunningEvent.OnServerEvent:Connect(function(plr, Value)
	
	local walkSpeedMultiplier = plr.walkSpeedMultiplier
	
	if Value then
		plr.Character.Humanoid.WalkSpeed = runSpeed * walkSpeedMultiplier.Value
	else
		plr.Character.Humanoid.WalkSpeed = walkSpeed * walkSpeedMultiplier.Value
	end
	
	plr.isRunning.Value = Value
	
end)

updateSpeed.OnServerEvent:Connect(function(plr, equippedTool, equipped)

	local walkSpeedMultiplier = plr.walkSpeedMultiplier
	--local tool = plr.Character:FindFirstChildOfClass("Tool")
	if equippedTool then
		if tools[equippedTool.Name] then -- Equipped
			if equipped == true then
				walkSpeedMultiplier.Value -= tools[equippedTool.Name]
			elseif equipped == false then -- Unequipped
				walkSpeedMultiplier.Value += tools[equippedTool.Name]
			end
		end
	end
	
	
	if plr.isRunning.Value == true then
		plr.Character.Humanoid.WalkSpeed = runSpeed * walkSpeedMultiplier.Value
	else
		plr.Character.Humanoid.WalkSpeed = walkSpeed * walkSpeedMultiplier.Value
	end
	
end)