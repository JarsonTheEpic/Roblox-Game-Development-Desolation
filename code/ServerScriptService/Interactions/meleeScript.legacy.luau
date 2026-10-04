local meleeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.meleeEvent
local addcd = game:WaitForChild("ReplicatedStorage").gameplayEvents.addCombatCooldown
local playSoundServer = game:WaitForChild("ReplicatedStorage").gameplayEvents.playSoundServer

local plrTipsEvent = game:WaitForChild("ReplicatedStorage").plrTipsEvent


local function resetWeapon(weapon)
	task.wait(weapon.cooldown.Value)
	weapon.usingTool.Value = false
end

-- Combat leave cooldown
local attackerCooldown = 30
local targetCooldown = 25

local npcMurderBounty = 100
local plrMurderBounty = 250


meleeEvent.OnServerEvent:Connect(function(plr, weapon)
	local usingTool = weapon.usingTool

	if usingTool.Value == true then return end
	
	local chargeTime = weapon.chargeTime
	local cooldown = weapon.cooldown
	local speedAdjustment = weapon.speedAdjustment
	--local cashAmount = weapon.cashAmount
	local attackAnimation = weapon.attackAnimation

	local armedPlr = game:GetService("Players"):GetPlayerFromCharacter(weapon.Parent)
	
	usingTool.Value = true

	local humanoid = armedPlr.Character.Humanoid
	local attackTrack = humanoid:LoadAnimation(attackAnimation)

	local attackSound = weapon:FindFirstChild("attackSound", 1)
	if attackSound then
		playSoundServer:Fire(attackSound, weapon, 15, 30)
	end
	--else
	--attackSound = attackSound:Clone()
	--attackSound.Parent = weapon
	--attackSound:Play()
	--attackSound:Destroy()
	--end

	attackTrack:Play()
	attackTrack:AdjustSpeed(speedAdjustment.Value)
	
	-- Waits the charge time, the melee needs a time to charge up before being able to deal damage
	task.wait(chargeTime.Value)
	
	--resetWeapon()
	
	local attacked = false
	
	for t = 0, 10, 1 do
		local params = OverlapParams.new()
		params.FilterDescendantsInstances = {weapon, weapon.Parent} -- Ignore weapon and wielder
		params.FilterType = Enum.RaycastFilterType.Exclude
		
		
		local parts = workspace:GetPartsInPart(weapon.Handle, params)

		for i, hit in parts do

			local plr = game:GetService("Players"):GetPlayerFromCharacter(weapon.Parent)
			local targetPlr = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
			local hum = hit.Parent:FindFirstChild("Humanoid")
			local char = hit.Parent
			local durability

			if hum and attacked == false and hum.Parent ~= plr.Character then

				addcd:FireClient(plr, attackerCooldown, 60)
				
				attacked = true
				

				local targetPlr = game.Players:GetPlayerFromCharacter(hit.Parent)
				if targetPlr then
					addcd:FireClient(targetPlr, targetCooldown, 30)
				end
				
				local canDamage = true

				local hitSound = weapon:FindFirstChild("hitSound", 1)
				if hitSound then
					playSoundServer:Fire(hitSound, weapon, 12, 30)
				end
				
				
				--else
				--hitSound = hitSound:Clone()
				--hitSound.Parent = weapon
				--hitSound:Play()
				--hitSound:Destroy()
				--end
				
				local previousHealth = hum.Health

				hum:TakeDamage(weapon.bladeDamage.Value)
				hum:TakeDamage(weapon.bluntDamage.Value)
				
				
				if hum.Health <= 0 and previousHealth > 0 then -- If the target got killed
					
					local plrBounty = plr.playerstats.Bounty
					local plrCrons = plr.leaderstats.Crons
					
					if char:FindFirstChild("npcType") then
						
						if char.bounty.Value <= 0 then -- If the killed NPC was innocent
							
							plrBounty.Value += npcMurderBounty
							
							plrTipsEvent:FireClient(plr, "You killed someone! Murder will always be punished in the land of Concordia!", 3)
							
						else
							
							local reward = char.bounty.Value
							
							plrCrons.Value += reward
							plrTipsEvent:FireClient(plr, "You received ".. reward.. " Crons bounty reward!", 3)

							char.bounty.Value = 0
							
						end
						
					elseif targetPlr then
						
						if targetPlr.playerstats.Bounty.Value <= 0 then -- If the killed player was innocent

							plrBounty.Value += plrMurderBounty

							plrTipsEvent:FireClient(plr, "You killed someone! Murder will always be punished in the land of Concordia!", 3)

						else
							
							local reward = targetPlr.playerstats.Bounty.Value
							local targetName = targetPlr.Name

							plrCrons.Value += reward
							plrTipsEvent:FireClient(plr, "You received ".. targetName.. "'s ".. reward.. " Crons bounty!", 3)

							targetPlr.playerstats.Bounty.Value = 0

						end
						
					end
					
				end
				
				
				-- If target is a NPC then aggro
				if char:FindFirstChild("npcType") and char.canAggro.Value == true and char.Humanoid.Health > char.escapeRequirement.Value then
					char.target.Value = plr.Name
					char.state.Value = "attack"
					char.aggroed.Value = true

				end

				if weapon:FindFirstChild("durability", true) then
					durability = weapon:FindFirstChild("durability", true)

					durability.Value -= 1
				end

				local broken = false

				if durability then
					if durability.Value <= 0 then
						broken = true
						weapon:Destroy()
					end
				end

				--if broken == true then return end

			end
		end
		
		task.wait(0.05)
	end
	
	task.wait(cooldown.Value - chargeTime.Value)

	usingTool.Value = false

end)