local players = game:GetService("Players")
local addcd = game:WaitForChild("ReplicatedStorage").gameplayEvents.addCombatCooldown


addcd.OnServerEvent:Connect(function(plr, combatState)
	
	--if combatState == true then
	--  print("Combat state of".. plr.Name.. ": True")
	--else
	--	print("Combat state of".. plr.Name.. ": False")
	--end
	plr.inCombat.Value = combatState
	
end)
