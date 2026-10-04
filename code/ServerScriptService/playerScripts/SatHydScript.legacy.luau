local function statsCheck(charisma, stamina, sanity, hygiene)
	if charisma.Value > 100 then
		charisma.Value = 100
	end
	if charisma.Value < 0 then
		charisma.Value = 0
	end
	
	if stamina.Value > 100 then
		stamina.Value = 100
	end
	if stamina.Value < 0 then
		stamina.Value = 0
	end
	
	if sanity.Value > 100 then
		sanity.Value = 100
	end
	if sanity.Value < 0 then
		sanity.Value = 0
	end

	if hygiene.Value > 100 then
		hygiene.Value = 100
	end
	if hygiene.Value < 0 then
		hygiene.Value = 0
	end
end

game.Players.PlayerAdded:Connect(function(plr)

	repeat wait() until plr.playerstats.Saturation

	local saturation = plr.playerstats.Saturation
	local hydration = plr.playerstats.Hydration

	local cooldown = 2
	local maxSaturation = 100
	local maxHydration = 100
	local hungerDamage = 1
	local thirstDamage = 1
	
	local charisma = plr.playerstats.Charisma
	local stamina = plr.playerstats.Stamina
	local sanity = plr.playerstats.Sanity
	local hygiene = plr.playerstats.Hygiene

	plr.CharacterAdded:Connect(function()
		local hum = plr.Character:WaitForChild("Humanoid")
		
		saturation.Value = maxSaturation
		hydration.Value = maxHydration
		
		local isRunning = plr.isRunning

		while plr.Character do
			
			task.wait(cooldown)
			if hum.Health > 0 and plr.inLobby.Value == false then
				
				if saturation.Value > 0 then
					
					saturation.Value = saturation.Value - 0.1
					if isRunning.Value == true then
						saturation.Value = saturation.Value - 0.2
					end
					
				end
				if saturation.Value > maxSaturation then

					saturation.Value = maxSaturation

				end
				if saturation.Value < 5 then
					hum:TakeDamage(hungerDamage)
				end

				if hydration.Value > 0 then

					hydration.Value = hydration.Value - 0.1
					if isRunning.Value == true then
						hydration.Value = hydration.Value - 0.2
					end

				end
				if hydration.Value > maxHydration then

					hydration.Value = maxHydration

				end
				if hydration.Value < 5 then
					hum:TakeDamage(thirstDamage)
				end
				
				if saturation.Value > 90 and hydration.Value > 90 and isRunning.Value == false and hum.Health < hum.MaxHealth then
					hum:TakeDamage(-2)
				end
				if hum.Health > hum.MaxHealth then
					hum.Health = hum.MaxHealth
				end
				
				statsCheck(charisma, stamina, sanity, hygiene)
			end
		end
	end)
end)