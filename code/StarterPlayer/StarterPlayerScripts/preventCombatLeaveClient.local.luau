local addcd = game:WaitForChild("ReplicatedStorage").gameplayEvents.addCombatCooldown

repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer

task.wait(3)
local playerGui = plr.PlayerGui
local combatNotice = playerGui.combatNotice

local cooldown = 0

addcd.OnClientEvent:Connect(function(addTime, maximum)
	
	if cooldown + addTime > maximum then
		cooldown = maximum
	else
		cooldown += addTime
	end
	
end)

while true do
	
	task.wait(1)
	
	if plr.inCombat.Value then -- If player is inCombat add warning
		combatNotice.Enabled = true
	else
		combatNotice.Enabled = false
	end
	
	if cooldown > 0 then
		addcd:FireServer(true) -- Tells the server to set player's inCombat variable to true
		cooldown -= 1
	else
		addcd:FireServer(false)
	end
	
end