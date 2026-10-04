local rs = game:WaitForChild("ReplicatedStorage")
local ss = game:WaitForChild("ServerStorage")

local players = game:GetService("Players")
local cs = game:GetService("CollectionService")

local serverRemote = rs.gameplayEvents.gunRemotes.serverGunRemote
local clientRemote = rs.gameplayEvents.gunRemotes.clientGunHandler
local hitmarkEvent = rs.gameplayEvents.gunRemotes.gunHitmarker
local ADSEvent = rs.gameplayEvents.gunRemotes.ADSEvent
local reloadEvent = rs.gameplayEvents.gunRemotes.reloadEvent
local addcd = rs.gameplayEvents.addCombatCooldown
local playSoundServer = rs.gameplayEvents.playSoundServer


local plrTipsEvent = rs.plrTipsEvent
local partDestroy = ss.Events.partDestroy


local glassBreak = script.glassBreak

local helmets = ss.Accessories.Armor.Helmet
local vests = ss.Accessories.Armor.Vest
local leggings = ss.Accessories.Armor.Legging


local attackerCooldown = 30
local targetCooldown = 25


local npcMurderBounty = 100
local plrMurderBounty = 250
local RANGE = 1000

local gunStats = { -- Name, Damage, Body Multipler, Headshot Multipler, Pellet count, Firerate, Aimspeed, Reload time, Cartridge
	M4A1 = {"M4A1", -- Name
		40, -- Base Damage (Limb damage)
		1.2, -- Body Multipler
		2, -- Headshot Multiplier
		1, -- Pellet count
		1 / 13.3, -- Firerate
		0.2, -- Aim time
		2.8, -- Reload time
		"a556x45mm", -- Cartridge
		800, -- Bullet velocity 
		0, -- Spread XYZ, it is divided by 1000, hip accuracy It must be divided by 1000 later cus roblox cant handle random decimal generation
		0,
		0,
		0, -- Spread XYZ, it is divided by 1000, aimed accuracy
		0,
		0,
		false,
		0.55, -- Armor penetration
		damageDropoff = 0.91 -- Loses 9% of damage per 50 studs
	},
	
	AK47 = {"AK47", -- Name
		48, -- Base Damage (Limb damage)
		1.2, -- Body Multipler
		2.25, -- Headshot Multiplier
		1, -- Pellet count
		1 / 10, -- Firerate
		0.2, -- Aim time
		3.8, -- Reload time
		"a762x39mm", -- Cartridge
		800, -- Bullet velocity 
		150, -- Spread XYZ, it is divided by 1000, hip accuracy
		150,
		150,
		50, -- Spread XYZ, it is divided by 1000, aimed accuracy
		50,
		50,
		false,
		0.6, -- Armor penetration
		damageDropoff = 0.94 
	},
	
	["Scar-L"] = {"Scar-L", -- Name
		45, -- Base Damage (Limb damage)
		1.2, -- Body Multipler
		2.5, -- Headshot Multiplier
		1, -- Pellet count
		1 / 10.8, -- Firerate
		0.2, -- Aim time
		2.8, -- Reload time
		"a556x45mm", -- Cartridge
		800, -- Bullet velocity 
		120, -- Spread XYZ, it is divided by 1000, hip accuracy
		120,
		120,
		25, -- Spread XYZ, it is divided by 1000, aimed accuracy
		25,
		25,
		false,
		0.72, -- Armor penetration
		damageDropoff = 0.97 
	},
	
	Makarov = {"Makarov", -- Name
		35, -- Base Damage (Limb damage)
		1.2, -- Body Multipler
		3, -- Headshot Multiplier
		1, -- Pellet count
		1 / 5, -- Firerate
		0.1, -- Aim speed
		1.5, -- Reload time	
		"a9x18mm", -- Cartridge
		400, -- Bullet velocity
		150,
		150,
		150,
		40,
		40,
		40,
		false,
		0.2, -- Armor penetration
		damageDropoff = 0.81 
	},
	
	GCP45 = {"GCP45", -- Name
		45, -- Base Damage (Limb damage)
		1.2, -- Body Multipler
		2.5, -- Headshot Multiplier
		1, -- Pellet count
		1 / 4, -- Firerate
		0.1, -- Aim speed
		1.5, -- Reload time	
		"a45Auto", -- Cartridge
		400, -- Bullet velocity
		150,
		150,
		150,
		40,
		40,
		40,
		false,
		0.25, -- Armor penetration
		damageDropoff = 0.85 
	},

	CAP10 = {"CAP10", -- Name
		30, -- Base Damage (Limb damage)
		1.2, -- Body Multipler
		1.5, -- Headshot Multiplier
		1, -- Pellet count
		1 / 18, -- Firerate
		0.1, -- Aim speed
		2.25, -- Reload time	
		"a45Auto", -- Cartridge
		400, -- Bullet velocity
		150,
		150,
		150,
		40,
		40,
		40,
		false,
		0.2, -- Armor penetration
		damageDropoff = 0.79 
	},
	
	GMP45 = {"GMP45", -- Name
		36, -- Base Damage (Limb damage)
		1, -- Body Multipler
		2, -- Headshot Multiplier
		1, -- Pellet count
		1 / 11, -- Firerate
		0.1, -- Aim speed
		2.25, -- Reload time	
		"a45Auto", -- Cartridge
		400, -- Bullet velocity
		150,
		150,
		150,
		40,
		40,
		40,
		false,
		0.25, -- Armor penetration
		damageDropoff = 0.82 
	},
	
	AWM = {"AWM", -- Name
		120, -- Base Damage (Limb damage)
		1.5, -- Body Multipler
		2.2, -- Headshot Multiplier
		1, -- Pellet count
		3 / 2, -- Firerate
		0.25, -- Aim speed
		2.8, -- Reload time	
		"a338Lapua", -- Cartridge
		100, -- Bullet velocity
		0,
		0,
		0,
		0,
		0,
		0,
		true,
		0.9, -- Armor penetration
		damageDropoff = 0.98 
	}
}

local scopes = {
	"AWM"
}

local cooldown = { -- plr, gun, coolDown
	
}

local ignoreParts = {
	"glassPane", 
	"borderFence", 
	"bulletHole"
}


local function createAttachment(parent, position)
	local a = Instance.new("Attachment")
	a.WorldPosition = position
	a.Parent = parent
	return a
end


local function createTracer(startPos, endPos)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(0.1, 0.1, 0.1)
	part.Parent = workspace

	local a0 = createAttachment(part, startPos)
	local a1 = createAttachment(part, endPos)

	local beam = Instance.new("Beam")
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.FaceCamera = true
	beam.Width0 = 0.08
	beam.Width1 = 0.02
	beam.LightEmission = 1
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 180, 30))
	beam.Parent = part

	task.delay(0.05, function()
		part:Destroy()
	end)
end


partDestroy.Event:Connect(function(part, respawnTime)
	
	
	if cs:HasTag(part.Parent.Name, "explosiveBarrel") then -- If the interacted part is an explosive barrel
	
		--grenade.Explode:Play() -- BOOOOM explodes

		--local radius = 50			

		--local detectionParams = OverlapParams.new()
		--detectionParams.FilterType = Enum.RaycastFilterType.Exclude
		--detectionParams.FilterDescendantsInstances = {grenade}

		--local nearby = workspace:GetPartBoundsInRadius(grenade.Position, radius, detectionParams)

		--local alreadyDamaged = {} -- Table to check if the Character has already been damaged

		--local params =  RaycastParams.new() -- Sets raycast parameters
		--params.FilterType = Enum.RaycastFilterType.Exclude
		--params.FilterDescendantsInstances = {grenade, grenade:GetChildren()}
		--params.IgnoreWater = true

		--for i, part in pairs(nearby) do
		--	local character = part:FindFirstAncestorOfClass("Model")

		--	if character and character:FindFirstChild("Humanoid") then -- Only looks for HumanoidRootPart

		--		local direction = (part.Position - grenade.Position).unit * 1000

		--		local results = workspace:Raycast(grenade.Position, direction, params)
		--		if results.Instance.Parent ~= character then continue end -- continues if the raycast hits a wall


		--		if table.find(alreadyDamaged, character) then continue end -- Checks if the humanoid has already taken damage

		--		table.insert(alreadyDamaged, character)

		--		local hum = character.Humanoid
		--		local distance = (grenade.Position - character.HumanoidRootPart.Position).Magnitude
		--		local damage = 500 - distance * 10 -- X maximum damage, loses Y damage every stud away from the bomb
		--		print(damage)

		--		if damage > 0 then
		--			hum:TakeDamage(damage)
		--		end

		--	end

		--end


		--alreadyDamaged = {}
		--local doorDestructionRadius = radius * 1
		--local nearby = workspace:GetPartBoundsInRadius(grenade.Position, doorDestructionRadius, detectionParams)
		--for i, part in pairs(nearby) do

		--	local door = part:FindFirstAncestorOfClass("Model")

		--	if part.Name == "vaultDoor" or cs:HasTag(door, "singleDoor") or part.Name == "door" then -- Blows up doors and vault doors

		--		if door:FindFirstChild("available") then
		--			if door.available.Value == false then continue end
		--		end

		--		print(door)
		--		local direction = (part.Position - grenade.Position).unit * 1000

		--		local results = workspace:Raycast(grenade.Position, direction, params)

		--		if results.Instance.Parent ~= door then 
		--			print(results.Instance.Name)
		--			print("hit wall")
		--			continue 
		--		end -- continues if the raycast hits a wall, so the C4 can't blow up doors through walls


		--		if table.find(alreadyDamaged, door) then 
		--			print("already blew up")
		--			continue 
		--		end -- The door already blew up
		--		table.insert(alreadyDamaged, door)

		--		task.spawn(function()
		--			doorExplode:Fire(door)
		--		end)

		--	end

		--	task.spawn(function()
		--		partDestroy:Fire(part, 30) -- Destroys the part IF it can be destroyed
		--	end)

		--end


		--local explosion = Instance.new("Explosion") -- Creates the explosion effect
		--explosion.BlastPressure = 400000 -- The explosion effect must be after the calculation, or the door won't be blasted
		--explosion.DestroyJointRadiusPercent = 0
		--explosion.BlastRadius = radius
		--explosion.ExplosionType = Enum.ExplosionType.NoCraters
		--explosion.Position = grenade.Position
		--explosion.Parent = grenade
		
	elseif part.Name == "glassPane" then

		local sound = glassBreak:Clone()
		sound.Parent = part
		sound:Destroy()

		local originalTransparency = part.Transparency

		part.Transparency = 1
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false

		task.spawn(function()

			task.wait(respawnTime)

			part.Transparency = originalTransparency
			part.CanCollide = true
			part.CanTouch = true
			part.CanQuery = true

		end)
		
	end
	
end)


local function checkBounty(plr, char, hum, previousHealth)
	
	if hum.Health <= 0 and previousHealth > 0 then -- If the target got killed

		local plrBounty = plr.playerstats.Bounty
		local plrCrons = plr.leaderstats.Crons

		local targetPlr = players:GetPlayerFromCharacter(char)

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
	
end


local function applyDamage(plr, gun, hit, hum, char, distance)

	addcd:FireClient(plr, attackerCooldown, 300)
	
	
	local hitArmor = ""
	local damage = gunStats[gun.Name][2]
	local armorPenetration = gunStats[gun.Name][18]
	
	if hit.Name == "plrBodyHitbox" or hit.Name == "UpperTorso" or hit.Name == "LowerTorso" or hit.Name == "HumanoidRootPart" or hit.Name == "LeftHand" or hit.Name == "RightHand" or hit.Name == "LeftUpperArm" or hit.Name == "RightUpperArm" or hit.Name == "LeftLowerArm" or hit.Name == "RightLowerArm" then
		
		hitArmor = "Vest"

	elseif hit.Name == "plrHeadHitbox" or hit.Name == "Head" then
		
		hitArmor = "Helmet"
		
	else
		
		hitArmor = "Legging"

	end

	
	local hasArmor -- If hit character has armor that protected the hit area
	local canHit = true -- Once calculated armor damage then normal damage won't be calculated and applied anymore
	
	if players:GetPlayerFromCharacter(hit.Parent) then -- Gives a combat cooldown to the player that got hit
		addcd:FireClient(players:GetPlayerFromCharacter(hit.Parent), targetCooldown, 150)
	end
	
	-- Loops through every part of the character and checks if its an armor that matches with the hit body part
	for i, child in pairs (char:GetChildren()) do
		
		
		if child:FindFirstChild("armorType") then -- If the child is an armor accessory
			
			local armorType = child:FindFirstChild("armorType")
			
			if armorType.Value == hitArmor then -- If it is the correct armor type
				
				--if canHit == false then return end
				
				canHit = false
				
				hasArmor = true
								
				local rangedProtection = child.toolStats.rangedProtection
				local rangedProt = rangedProtection.Value * 0.01
				local finalArmorValue = 1 - ( (rangedProt) * (1 - armorPenetration) )
				


				-- Applies durability changes
				local durability = child.toolStats.durability
				durability.Value -= damage
				
				local distanceMultipler = distance // 50
				distanceMultipler = gunStats[gun.Name].damageDropoff ^ distanceMultipler
				
				damage = damage * finalArmorValue * distanceMultipler -- Damage here is still base damage not multiplied by body multipliers
								
				local previousHealth = hum.Health
				
				if hit.Name == "plrBodyHitbox" or hit.Name == "UpperTorso" or hit.Name == "LowerTorso" or hit.Name == "HumanoidRootPart" or hit.Name == "LeftHand" or hit.Name == "RightHand" or hit.Name == "LeftUpperArm" or hit.Name == "RightUpperArm" or hit.Name == "LeftLowerArm" or hit.Name == "RightLowerArm" then

					hum:TakeDamage(damage * gunStats[gun.Name][3])
					hitmarkEvent:FireClient(plr, math.floor(damage * gunStats[gun.Name][3]), hit, "orange")

				elseif hit.Name == "plrHeadHitbox" or hit.Name == "Head" then
					
					hum:TakeDamage(damage * gunStats[gun.Name][4])
					hitmarkEvent:FireClient(plr, math.floor(damage * gunStats[gun.Name][4]), hit, "red")
					
				else
					
					hum:TakeDamage(damage)
					hitmarkEvent:FireClient(plr, math.floor(damage), hit, "yellow")
					
				end
				
				
				checkBounty(plr, char, hum, previousHealth)

			end
		end
		
	end
	
	if canHit then

		canHit = false

		local distanceMultipler = distance // 50
		distanceMultipler = gunStats[gun.Name].damageDropoff ^ distanceMultipler

		damage = damage * distanceMultipler


		local previousHealth = hum.Health
		
		--print(hit.Name)

		if hit.Name == "plrBodyHitbox" or hit.Name == "UpperTorso" or hit.Name == "LowerTorso" or hit.Name == "HumanoidRootPart" or hit.Name == "LeftHand" or hit.Name == "RightHand" or hit.Name == "LeftUpperArm" or hit.Name == "RightUpperArm" or hit.Name == "LeftLowerArm" or hit.Name == "RightLowerArm" then

			hum:TakeDamage(damage * gunStats[gun.Name][3])
			hitmarkEvent:FireClient(plr, math.floor(damage * gunStats[gun.Name][3]), hit, "orange")

		elseif hit.Name == "plrHeadHitbox" or hit.Name == "Head" then

			hum:TakeDamage(damage * gunStats[gun.Name][4])
			hitmarkEvent:FireClient(plr, math.floor(damage * gunStats[gun.Name][4]), hit, "red")

		else

			hum:TakeDamage(damage)
			hitmarkEvent:FireClient(plr, math.floor(damage), hit, "yellow")

		end

		checkBounty(plr, char, hum, previousHealth)

	end
	
end



local function castRay(plr, gun, origin, mouseAim, distance, spreadOffset, depth) -- Depth is the maximum amount of penetration, to prevent infinite loops
	
	if depth > 5 then 
		return
	end
	
	depth += 1
	
	local ignore = {}

	for _,v in ipairs(plr.Character:GetDescendants()) do
		table.insert(ignore, v)
	end

	for _,v in ipairs(gun:GetDescendants()) do
		table.insert(ignore, v)
	end
	
	local params =  RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = ignore
	params.IgnoreWater = true
	
	local direction = (mouseAim - origin).Unit
	
	
	local raycastDirection = (mouseAim - origin + spreadOffset) * 30
	--origin = origin + raycastDirection * 1


	local results = workspace:Raycast(origin, raycastDirection, params) -- 1000 is the range of the ray
	local hit = false
	local recast = false
		
	if results then -- Checks if the hit instance is glass
		if results.Instance.Name == "glassPane" then
			task.spawn(function()

				partDestroy:Fire(results.Instance, 30)

			end)
		end
	end

	
	
	for i, item in pairs(ignoreParts) do -- If it hit an ignorePart, then cast the ray again (penetrates the part)
		
		if results == nil then return end
		
		if results.Instance.Name == item then
			recast = true
		end
		
	end


	if results then
		
		
		local part = results.Instance
		--if part.Name == "Handle" or part.Parent == gun then
		--	print("blocked by part")
		--	print(part.Name)
			
		--	return 
		--end
		local char = part:FindFirstAncestorOfClass("Model")
		

		local tracer = Instance.new("Part")
		tracer.Size = Vector3.new(0.04, 0.04, distance)
		tracer.CFrame = CFrame.new(gun.Handle.Position, results.Position) * CFrame.new(0, 0, -distance / 2)
		tracer.Color = Color3.fromRGB(255, 165, 0) -- Orange
		tracer.Name = "tracer"
		tracer.Material = Enum.Material.Neon
		tracer.Anchored = true
		tracer.Transparency = 0.75
		tracer.CanCollide = false
		tracer.CanQuery = false
		tracer.Parent = workspace
		
		game.Debris:AddItem(tracer, 0.25)
		
		local hum = nil
		if char then
			hum = char:FindFirstChild("Humanoid")
		end
		
		if hum == nil then -- If it didn't hit a character, then leave a bullet hole
			local bulletHole = Instance.new("Part")
			bulletHole.Name = "bulletHole"
			bulletHole.Anchored = false
			bulletHole.Massless = false
			bulletHole.Size = Vector3.new(0.065, 0.065, 0.065)
			bulletHole.BrickColor = BrickColor.new("Black metallic")
			bulletHole.CanQuery = false
			bulletHole.CanCollide = false
			bulletHole.CanTouch = false
			bulletHole.Parent = game.Workspace
			bulletHole.Position = results.Position

			local bulletWeld = Instance.new("WeldConstraint")
			bulletWeld.Parent = game.Workspace
			bulletWeld.Part0 = bulletHole
			bulletWeld.Part1 = part
			game.Debris:AddItem(bulletWeld, 30)
			
			game.Debris:AddItem(bulletHole, 30)
		end


		if char and char:FindFirstChild("Humanoid") and char.Name ~= plr.Name then
			if hit == true then return end
			hit = true
			local hum = char:FindFirstChild("Humanoid")

			applyDamage(plr, gun, part, hum, char, distance)

			-- Checks if its NPC for aggro
			if char:FindFirstChild("npcType") and char.canAggro.Value == true and char.Humanoid.Health > char.escapeRequirement.Value then
				char.target.Value = plr.Name
				char.state.Value = "attack"
				char.aggroed.Value = true
			end

			local found = false

			for i, item in cooldown do
				if item[1] == plr and item[2] == gun.Name then
					found = true
					return 
				end
			end
			
		elseif recast then			
			local newStartPos = results.Position

			--spreadOffset = Vector3.new(0, 0, 0)
			
			castRay(plr, gun, newStartPos, mouseAim, distance, spreadOffset, depth)
			
		end

	end
end



ADSEvent.OnServerEvent:Connect(function(plr, ads, gun)
	
	local success, err = pcall(function()
		
		if ads == true then
			task.wait(gunStats[gun.Name][7] / 2)

			local guis = plr.PlayerGui

			if gunStats[gun.Name][17] == true then
				guis.scopeGui.Enabled = true
				guis.Meters.Enabled = false
				guis.toolGui.ammoGui.Enabled = false
				guis.playerInfo.Enabled = false
				gun.Handle.Transparency = 1
				for i, part in gun.Handle.hideParts:GetChildren() do
					part.Transparency = 1
				end
			end

			task.wait(gunStats[gun.Name][7] / 2)

			gun.aimed.Value = true
		else
			-- task.wait(gunStats[gun.Name][7] / 2)
			gun.aimed.Value = false
			local guis = plr.PlayerGui


			if gunStats[gun.Name][17] == true then
				guis.scopeGui.Enabled = false
				guis.Meters.Enabled = true
				guis.toolGui.ammoGui.Enabled = true
				guis.playerInfo.Enabled = true
				gun.Handle.Transparency = 0
				for i, part in gun.Handle.hideParts:GetChildren() do
					part.Transparency = 0
				end
			end
		end
		
	end)
	
end)




reloadEvent.OnServerEvent:Connect(function(plr, reload, gun)
	
	local success, err = pcall(function()
		
		local plrAmmo = plr.plrAmmo

		if reload == true then
			local reloadSound = gun:FindFirstChild("reloadSound", 1)
			if reloadSound then
				playSoundServer:Fire(reloadSound, gun, 20, 40)
			end

			gun.reloading.Value = true

			local canReload = true

			for i = 0, gunStats[gun.Name][8], 0.1 do
				if gun.Parent ~= plr.Character then canReload = false end
				task.wait(0.1)
			end

			if canReload == false then return end

			if plrAmmo[gunStats[gun.Name][9]].Value >= gun.maxAmmo.Value - gun.toolStats.ammoLeft.Value then
				plrAmmo[gunStats[gun.Name][9]].Value -= gun.maxAmmo.Value - gun.toolStats.ammoLeft.Value
				gun.toolStats.ammoLeft.Value = gun.maxAmmo.Value
			else
				gun.toolStats.ammoLeft.Value += plrAmmo[gunStats[gun.Name][9]].Value
				plrAmmo[gunStats[gun.Name][9]].Value = 0
			end

			gun.reloading.Value = false

		else
			task.wait(0.5 * gunStats[gun.Name][8])
			gun.reloading.Value = false
		end

	end)
	
end)



-- SHOOTING LOGIC
serverRemote.OnServerEvent:Connect(function(plr, direction, mouseAim, gun, isAimed, mouseRay, origin, position)
	
	-- Play sounds
	local fireSound = gun:FindFirstChild("fireSound", 1)
	if fireSound then
		playSoundServer:Fire(fireSound, gun, nil, nil)
	end
	
	-- Won't shoot if requirements not met
	if gun.toolStats.ammoLeft.Value <= 0 then return end
	if gun.toolStats.durability.Value <= 0 then return end
	
	local canFire = true
	
	for i, item in cooldown do
		if item[2] == plr.Name then
			print("stopped due to overfire")
			canFire = false
			return
		end
	end
	
	if canFire == false then return end
	
	
	-- Initialises variables
	local startPos = gun.Handle.Barrel.Position
	local trueDirection = (mouseAim - startPos).unit * 1000
	local distance = (mouseAim - startPos).magnitude

	local spreadOffset = Vector3.new(0, 0, 0)
	
	local spreadX = 0
	local spreadY = 0
	local spreadZ = 0
		
	--if gun.aimed.Value == true then
	--	spreadX = ((math.random(0 - gunStats[gun.Name][14], gunStats[gun.Name][14]) / 10000) * distance)
	--	spreadY = ((math.random(0 - gunStats[gun.Name][15], gunStats[gun.Name][15]) / 10000) * distance)
	--	spreadZ = ((math.random(0 - gunStats[gun.Name][16], gunStats[gun.Name][16]) / 10000) * distance)
	--else
	--	spreadX = ((math.random(0 - gunStats[gun.Name][11], gunStats[gun.Name][11]) / 10000) * distance)
	--	spreadY = ((math.random(0 - gunStats[gun.Name][12], gunStats[gun.Name][12]) / 10000) * distance)
	--	spreadZ = ((math.random(0 - gunStats[gun.Name][13], gunStats[gun.Name][13]) / 10000) * distance)
	--end
	
	
	local spreadOffset = Vector3.new(spreadX, spreadY, spreadZ)
	trueDirection = trueDirection + spreadOffset
	
	
	createTracer(gun.Handle:FindFirstChild("Barrel").Position, mouseAim)

	
	castRay(plr, gun, origin, mouseAim, distance, spreadOffset, 0)

		
	clientRemote:FireAllClients(plr, gun) -- Play the VFX on the client side
	
	table.insert(cooldown, {plr, gun.Name, gunStats[gun.Name][6]})

	
	local Midpoint = (startPos + mouseAim) / 2


	gun.toolStats.ammoLeft.Value -= 1  -- Take away ammo and durability

	if gun.toolStats.durability.Value > 0 then
		gun.toolStats.durability.Value -= 1
	end

		
	for i, item in cooldown do
		if item[1] == plr and item[2] == gun.Name then
			table.remove(cooldown, i)
			return 
		end
	end
	
end)

while true do
	
	--if #cooldown == 0 then return end
	
	for i, item in cooldown do
		if item[3] <= 0 then
			table.remove(cooldown, i)
		else
			item[3] = item[3] - 0.01
		end
	end
	task.wait()
end
