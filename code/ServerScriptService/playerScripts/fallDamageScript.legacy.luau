local fallDamage = game:WaitForChild("ReplicatedStorage").calculateFallDamage

local maxHeightWithoutDamage = 1.4



fallDamage.OnServerEvent:Connect(function(plr, velocity, fellHeight, landHeight)
	
	if landHeight > fellHeight then return end -- If the player went up, then no fall damage
	
	local damage = (fellHeight - landHeight) * 4 - 40
		
	if damage > 0 then
		plr.Character.Humanoid:TakeDamage(damage)
		local damageSoundClone = script.damageSound:Clone()
		damageSoundClone.Parent = plr.Character.HumanoidRootPart
		damageSoundClone:Destroy()
	end	
	
end)
