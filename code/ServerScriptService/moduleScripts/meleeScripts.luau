local module = {
	
}

-- local slashSound = game:WaitForChild("ReplicatedStorage").SwordSlash
local addcd = game:WaitForChild("ReplicatedStorage").gameplayEvents.addCombatCooldown

local players = game:GetService("Players")

local attackerCooldown = 30
local targetCooldown = 25

function module.meleeSwing(weapon)
	
	local usingTool = weapon.usingTool
	
	local cooldown = weapon.cooldown
	local speedAdjustment = weapon.speedAdjustment
	--local cashAmount = weapon.cashAmount
	local attackAnimation = weapon.attackAnimation
	
	local armedPlr = game:GetService("Players"):GetPlayerFromCharacter(weapon.Parent)


	if usingTool.Value == false then

		usingTool.Value = true

		local humanoid = armedPlr.Character.Humanoid
		local attackTrack = humanoid:LoadAnimation(attackAnimation)
		
		local attackSound = weapon:FindFirstChild("attackSound")
		if attackSound then
			attackSound:Play()
		end
		--else
			--attackSound = attackSound:Clone()
			--attackSound.Parent = weapon
			--attackSound:Play()
			--attackSound:Destroy()
		--end

		attackTrack:Play()
		attackTrack:AdjustSpeed(speedAdjustment.Value)
		
		task.wait(cooldown.Value)
		
		usingTool.Value = false
	end
end

function module.meleeHit(weapon, hit)
	
	local usingTool = weapon.usingTool
	local db = weapon.db
	local cooldown = weapon.cooldown
	local speedAdjustment = weapon.speedAdjustment
	local attackAnimation = weapon.attackAnimation
	
	local plr = game:GetService("Players"):GetPlayerFromCharacter(weapon.Parent)
	local targetPlr = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
	local hum = hit.Parent:FindFirstChild("Humanoid")

	
	if hum and usingTool.Value == true and db.Value == true then

		db.Value = false

		if hum.Parent ~= plr.Character then
			
			addcd:FireClient(plr, attackerCooldown, 300)
			
			local targetPlr = game.Players:GetPlayerFromCharacter(hit.Parent)
			
			local hitSound = weapon:FindFirstChild("hitSound")
			if hitSound then
				hitSound:Play()
			end
			--else
				--hitSound = hitSound:Clone()
				--hitSound.Parent = weapon
				--hitSound:Play()
				--hitSound:Destroy()
			--end
			
			if players:GetPlayerFromCharacter(hit.Parent) then
				addcd:FireClient(players:GetPlayerFromCharacter(hit.Parent), targetCooldown, 300)
			end
			
			hum:TakeDamage(weapon.bladeDamage.Value)
			hum:TakeDamage(weapon.bluntDamage.Value)

		end
	end
	
end

return module
