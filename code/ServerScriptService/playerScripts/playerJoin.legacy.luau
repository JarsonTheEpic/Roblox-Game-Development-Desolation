local debris = game:GetService("Debris")

local function giveForcefield(plr, duration)
	
	for i, v in plr.Character:GetChildren() do
		if v.Name == "ForceField" then
			v:Destroy()
		end
	end
	
	local spawnProtection = Instance.new("ForceField")
	spawnProtection.Parent = plr.Character
	debris:AddItem(spawnProtection, duration)

end

game.Players.PlayerAdded:Connect(function(plr)
	
	repeat wait() until plr.Character
	
	giveForcefield(plr, 9999) -- Protection when first join game
	
	plr.CharacterAdded:Connect(function()
		
		if plr.inLobby == true then -- Protection in lobby
			giveForcefield(plr, 9999)
		else
			for i, v in plr.Character:GetChildren() do
				if v.Name == "ForceField" then
					v:Destroy()
				end
			end
		end
		
		repeat wait() until plr.playerstats
		local plrstats = plr.playerstats

		local hygiene = plrstats.Hygiene
		local charisma = plrstats.Charisma
		local stamina = plrstats.Stamina
		local sanity = plrstats.Sanity

		while true do

			wait()

			if hygiene.Value < 0 then
				hygiene.Value = 0
			elseif hygiene.Value > 100 then
				hygiene.Value = 100
			end

			if charisma.Value < 0 then
				charisma.Value = 0
			elseif charisma.Value > 100 then
				charisma.Value = 100
			end

			if stamina.Value < 0 then
				stamina.Value = 0
			elseif stamina.Value > 100 then
				stamina.Value = 100
			end

			if sanity.Value < 0 then
				sanity.Value = 0
			elseif sanity.Value > 100 then
				sanity.Value = 100
			end


		end
		
	end)
	
end)