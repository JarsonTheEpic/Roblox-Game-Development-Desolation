local module = {}



function module.eat(tool)
	if tool.isUsing.Value == true then return end
	
	local food = tool
	local eatAnim = food.eatAnimation
	local eatSound = food.eatSound
	local Uses = food.toolStats.Uses
	local saturationRestore = food.saturationRestore
	local hydrationRestore = food.hydrationRestore
	
	local charismaRestore = food.charismaRestore
	local hygieneRestore = food.hygieneRestore
	local sanityRestore = food.sanityRestore
	local staminaRestore = food.staminaRestore
	
	local healthRestore = food.healthRestore
	local cooldown = 0
	local maxCooldown = 2

	food.ToolTip = "Uses left: ".. Uses.Value

	local plr = game.Players:GetPlayerFromCharacter(tool.Parent)

	local hum = plr.Character.Humanoid

	local saturation = plr.playerstats.Saturation
	local hydration = plr.playerstats.Hydration
	
	local charisma = plr.playerstats.Charisma
	local hygiene = plr.playerstats.Hygiene
	local sanity = plr.playerstats.Sanity
	local stamina = plr.playerstats.Stamina
	
	local hum = plr.Character.Humanoid
	
	local maxSaturation = 100
	local maxHydration = 100

	if Uses.Value > 0 and cooldown == 0 then
		
		tool.isUsing.Value = true

		eatSound:Play()

		local eatAnimTrack = hum:LoadAnimation(eatAnim)
		eatAnimTrack:Play()
		
		task.wait(food.eatTime.Value) -- Waits the activation time after playing sound and animation


		Uses.Value = Uses.Value - 1

		if saturation.Value + saturationRestore.Value > maxSaturation then
			saturation.Value = maxSaturation
		else
			saturation.Value = saturation.Value + saturationRestore.Value
		end
		
		if hydration.Value + hydrationRestore.Value > maxHydration then
			hydration.Value = maxHydration
		else
			hydration.Value = hydration.Value + hydrationRestore.Value
		end
		
		if charisma.Value + charismaRestore.Value > 100 then
			charisma.Value = 100
		else
			charisma.Value = charisma.Value + charismaRestore.Value
		end

		if hygiene.Value + hygieneRestore.Value > 100 then
			hygiene.Value = 100
		else
			hygiene.Value = hygiene.Value + hygieneRestore.Value
		end
		
		if sanity.Value + sanityRestore.Value > 100 then
			sanity.Value = 100
		else
			sanity.Value = sanity.Value + sanityRestore.Value
		end

		if stamina.Value + staminaRestore.Value > 100 then
			stamina.Value = 100
		else
			stamina.Value = stamina.Value + staminaRestore.Value
		end
		
		if hum.Health + healthRestore.Value > hum.MaxHealth then
			hum.Health = hum.MaxHealth
		else
			hum.Health += healthRestore.Value
		end

		cooldown = maxCooldown
		task.wait(maxCooldown)
		cooldown = 0
		
		tool.isUsing.Value = false
	end

end

function module.useChanged(tool)
	local food = tool
	local Uses = tool.toolStats.Uses
	
	food.ToolTip = "Uses left: ".. Uses.Value

	if Uses.Value < 1 then

		task.wait(1.5)
		food:Destroy()

	end
end

return module
