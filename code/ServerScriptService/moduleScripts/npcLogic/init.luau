local module = {}

local addcd = game:WaitForChild("ReplicatedStorage").gameplayEvents.addCombatCooldown


local ss = game:WaitForChild("ServerStorage")
local rs = game:WaitForChild("ReplicatedStorage")
local pfs = game:GetService("PathfindingService")
local players = game:GetService("Players")
local physicsService = game:GetService("PhysicsService")
local tcs = game:GetService("TextChatService")
local chat = game:GetService("Chat")

local escapes = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").escapePoints
local spawns = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").spawnPoints
local patrols = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").patrolPoints -- The points for this NPC4

local R15 = require(game:WaitForChild("StarterPlayer"):WaitForChild("StarterCharacterScripts").ragdollDeath.R15)

local helmets = ss.Accessories.Armor.Helmet
local vests = ss.Accessories.Armor.Vest
local leggings = ss.Accessories.Armor.Legging

local playSoundServer = rs.gameplayEvents.playSoundServer

local cashModel = ss.Models.promptCash

local TARGET_COOLDOWN = 25
local MAX_CASH_MODELS_DROP = 4


local npcTable = {
	Civillian = {
		type = "Civillian",
		maxHealth = 100,
		health = 100,
		maxCount = 15,
		canSpawnNaturally = true,
		spawnMaximumRange = 30, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 28, script.Civillian1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 25, script.Civillian1.aggroRun},
			patrol = {1, 9, script.Civillian1.Walk}
		},
		escapeRequirement = 40, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.Civillian,
		escapes = escapes.Civillian,
		attackMethod = "melee",
		attackRange = 3.5,
		bluntDamage = 15,
		bladeDamage = 0,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.Civillian1.Attack,
		weapon = ss.Tools.Melees.Fists,
		spawnPoints = spawns.Civillian,
		randomPatrols = true,
		respawnTime = 5,
		bountyLimit = math.huge, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 60,
		onlyEquipWhenAggro = false
	},
	
	Civillian2 = {
		type = "Civillian2",
		maxHealth = 100,
		health = 100,
		maxCount = 15,
		canSpawnNaturally = true,
		spawnMaximumRange = 30, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 31, script.Civillian1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 25, script.Civillian1.aggroRun},
			patrol = {1, 9, script.Civillian1.Walk}
		},
		escapeRequirement = 40, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.Civillian,
		escapes = escapes.Civillian,
		attackMethod = "melee",
		attackRange = 3.5,
		bluntDamage = 0,
		bladeDamage = 45,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.Civillian1.Attack,
		weapon = ss.Tools.Melees["Kitchen knife"],
		spawnPoints = spawns.Civillian,
		randomPatrols = true,
		respawnTime = 5,
		bountyLimit = math.huge, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 60,
		onlyEquipWhenAggro = false
	},

	Villager1 = {
		type = "Villager1",
		maxHealth = 100,
		health = 100,
		maxCount = 9,
		canSpawnNaturally = true,
		spawnMaximumRange = 30, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 28, script.Villager1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 26, script.Villager1.aggroRun},
			patrol = {1, 8, script.Villager1.Walk}
		},
		escapeRequirement = 40, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.Villager1,
		escapes = escapes.Villager1,
		attackMethod = "melee",
		attackRange = 3.5,
		bluntDamage = 20,
		bladeDamage = 0,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.Villager1.Attack,
		weapon = ss.Tools.Melees.Fists,
		spawnPoints = spawns.Villager1,
		randomPatrols = true,
		respawnTime = 5,
		bountyLimit = math.huge, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 60,
		onlyEquipWhenAggro = false
	},

	villageGuard1 = {
		type = "villageGuard1",
		maxHealth = 150,
		health = 150,
		maxCount = 5,
		canSpawnNaturally = true,
		spawnMaximumRange = 30, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 28, script.villageGuard1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 26, script.villageGuard1.aggroRun},
			patrol = {1, 8, script.villageGuard1.Walk}
		},
		escapeRequirement = 0, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.villageGuard1,
		escapes = escapes.villageGuard1,
		attackMethod = "ranged",

		rangedDamage = 28,
		rangedPenetration = 0.15,
		rangedSpread = 800,
		rangedCooldown = 0.6,
		reloadTime = 2.5,
		reloadAdjust = 0.5,
		attackRange = 50,

		bluntDamage = 20,
		bladeDamage = 0,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.villageGuard1.Attack,
		spawnPoints = spawns.villageGuard1,
		randomPatrols = false,
		respawnTime = 20,
		bountyLimit = 10, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 80,
		onlyEquipWhenAggro = false
	},

	policePistol = { -- This police variant only spawns when a player has high enough bounty
		type = "policePistol",
		maxHealth = 150,
		health = 150,
		maxCount = 4,
		canSpawnNaturally = false,
		spawnMaximumRange = 200, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 28, script.villageGuard1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 26, script.villageGuard1.aggroRun}, -- Reuse animations lol
			patrol = {1, 8, script.villageGuard1.Walk}
		},
		escapeRequirement = 0, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.policePistol,
		escapes = escapes.policePistol,
		attackMethod = "ranged",

		rangedDamage = 30,
		rangedPenetration = 0.25,
		rangedSpread = 600,
		rangedCooldown = 0.8,
		reloadTime = 2.5,
		reloadAdjust = 0.5,
		attackRange = 50,

		bluntDamage = 20,
		bladeDamage = 0,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.villageGuard1.Attack,
		spawnPoints = spawns.policePistol,
		randomPatrols = false,
		respawnTime = 1,
		bountyLimit = 200, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 80,
		maxPerPlayer = 3, -- The maximum amount of this type of NPC that can attack one player at one time
		onlyEquipWhenAggro = false
	},
	
	policeSmg = { -- This police variant only spawns when a player has high enough bounty
		type = "policeSmg",
		maxHealth = 150,
		health = 150,
		maxCount = 4,
		canSpawnNaturally = false,
		spawnMaximumRange = 200, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 28, script.villageGuard1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 26, script.villageGuard1.aggroRun}, -- Reuse animations lol
			patrol = {1, 8, script.villageGuard1.Walk}
		},
		escapeRequirement = 0, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.policePistol,
		escapes = escapes.policePistol,
		attackMethod = "ranged",

		rangedDamage = 15,
		rangedPenetration = 0.25,
		rangedSpread = 750,
		rangedCooldown = 0.15,
		reloadTime = 2.2,
		reloadAdjust = 0.55,
		attackRange = 65,

		bluntDamage = 20,
		bladeDamage = 0,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.villageGuard1.Attack,
		spawnPoints = spawns.policePistol,
		randomPatrols = false,
		respawnTime = 1,
		bountyLimit = 200, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 80,
		maxPerPlayer = 3, -- The maximum amount of this type of NPC that can attack one player at one time
		onlyEquipWhenAggro = false
	},

	borderRanger1 = {
		type = "borderRanger1",
		maxHealth = 150,
		health = 150,
		maxCount = 4,
		canSpawnNaturally = true,
		spawnMaximumRange = 30, -- How close the player has to be for the NPC to spawn
		priorities = {
			escape = {10, 28, script.borderRanger1.Escape}, -- Importance (the higher the more important), Speed, movement animation
			attack = {9, 26, script.borderRanger1.aggroRun},
			patrol = {1, 8, script.borderRanger1.Walk}
		},
		escapeRequirement = 0, -- If its lower than this amount of health then escape
		canAggro = true,
		stayTime = 10,
		patrolPoints = patrols.borderRanger1,
		escapes = escapes.borderRanger1,
		attackMethod = "ranged",

		rangedDamage = 20,
		rangedPenetration = 0.4,
		rangedSpread = 600,
		rangedCooldown = 0.18,
		reloadTime = 2.5,
		reloadAdjust = 0.5,
		attackRange = 75,

		bluntDamage = 20,
		bladeDamage = 0,
		attackCooldown = 1,
		attackAnimSpeedAdjust = 1.2,
		attackTime = 1,
		attackAnim = script.borderRanger1.Attack,
		spawnPoints = spawns.borderRanger1,
		randomPatrols = false,
		respawnTime = 20,
		bountyLimit = 50, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 100,
		onlyEquipWhenAggro = false
	}
}


local npcDialogue = {
	Civillian = {
		patrol = {
			"What a nice day! I sure hope nothing bad happens",
			"How will I pay my rent?",
			"I miss how things used to be...",
			"Life in this city is a misery."
		},
		attack = {
			"COME BACK HERE!",
			"I'm NOT letting that slide!"
		},
		escape = {
			"Im out!",
			"HELP! I'M BEING ATTACKED!"
		},
		cooldown = 8
	},
	
	Civillian2 = {
		patrol = {
			"What a nice day! I sure hope nothing bad happens",
			"How will I pay my rent?",
			"I miss how things used to be...",
			"Life in this city is a misery."
		},
		attack = {
			"GET BACK HERE NOW!",
			"I'm NOT letting that slide!",
			"When I catch you, you are gonna regret some life choices..."
		},
		escape = {
			"Relax relax!"
		},
		cooldown = 8
	},
	
	Villager1 = {
		patrol = {
			"What a nice day! I sure hope nothing bad happens",
			"The city is getting more absurd everyday...",
			"So glad I'm not living in Solitudo"
		},
		attack = {
			"COME BACK HERE!",
			"I'm NOT letting that slide!"
		},
		escape = {
			"Im out!",
			"HELP! I'M BEING ATTACKED!"
		},
		cooldown = 8
	},
	
	villageGuard1 = {
		patrol = {
			"What a nice day! I sure hope nothing bad happens",
			"Nothing here",
			"Must've been the wind..."
		},
		attack = {
			"COME BACK HERE!",
			"I'm NOT letting that slide!"
		},
		escape = {
			"Im out!",
			"HELP! I'M BEING ATTACKED!"
		},
		cooldown = 8
	},
	
	policePistol = {
		patrol = {
			"What a nice day! I sure hope nothing bad happens",
			"Patrolling..."
		},
		attack = {
			"Suspect spotted!",
			"Suspect could be potentially dangerous!",
			"PUT YOUR HANDS UP WHERE I CAN SEE THEM!"
		},
		escape = {
			"I need urgent support!"
		},
		cooldown = 8
	},
	
	borderRanger1 = {
		patrol = {
			"These people think they can sneak in...",
			"Nothing is getting past me!",
		},
		attack = {
			"Suspect spotted!",
			"Suspect could be potentially dangerous!",
			"PUT YOUR HANDS UP WHERE I CAN SEE THEM!"
		},
		escape = {
			"I need urgent support! "
		},
		cooldown = 8
	}
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


local function setSpeed(npc, state, npcType)

	local hum = npc:FindFirstChild("Humanoid")
	if hum == nil then return end
	
	hum.WalkSpeed = npcTable[npcType].priorities[state][2]

end



local function npcTalk(npc, npcType, message)
	
	local head = npc:FindFirstChild("Head")
	if head == nil then return end
	
	if message then -- If the npc has to say a specific dialogue
		
		tcs:DisplayBubble(head, message, Enum.ChatColor.White)
		
	else -- The npc says a random piece of dialogue based on their current state
		
		local messageGroup = npcDialogue[npcType.Value][npc.state.Value]
		local randomMessage = messageGroup[math.random(1, #messageGroup)]
		
		chat:Chat(head, randomMessage, Enum.ChatColor.White)
		
	end
	
end



local function despawn(npc, timer)	
	if timer == nil then timer = 0 end
	
	task.wait(timer)
	
	npc:Destroy()
end


local function setCollisionGroup(char)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			physicsService:SetPartCollisionGroup(part, "npc")
		end
	end
end


local function setNetworkOwner(char)
	for i, bp in pairs(char:GetChildren()) do
		if bp:IsA("BasePart") and bp:CanSetNetworkOwnership() then
			bp:SetNetworkOwner()
		end
	end
end


local function applyDamage(npc, npcType, hit, hum, char, damageType)

	local hitArmor = ""
	local damage = npcTable[npcType.Value].rangedDamage
	local armorPenetration = npcTable[npcType.Value].rangedPenetration

	if hit.Name == "plrBodyHitbox" or hit.Name == "UpperTorso" or hit.Name == "LowerTorso" or hit.Name == "HumanoidRootPart" or hit.Name == "LeftHand" or hit.Name == "RightHand" or hit.Name == "LeftUpperArm" or hit.Name == "RightUpperArm" or hit.Name == "LeftLowerArm" or hit.Name == "RightLowerArm" then

		hitArmor = "Vest"

	elseif hit.Name == "plrHeadHitbox" or hit.Name == "Head" then

		hitArmor = "Helmet"

	else

		hitArmor = "Legging"

	end
	
	
	if players:GetPlayerFromCharacter(hit.Parent) then
		addcd:FireClient(players:GetPlayerFromCharacter(hit.Parent), TARGET_COOLDOWN, 300)
	end

	local hasArmor = false -- If hit character has armor that protected the hit area

	for i, child in pairs (char:GetChildren()) do



		if child:FindFirstChild("armorType") then -- If the child is an armor accessory

			local armorType = child:FindFirstChild("armorType")

			if armorType.Value == hitArmor then -- If it is the correct armor type
				
				--print("Hit correct armor: ".. armorType.Value)
				
				hasArmor = true

				local rangedProtection = child.toolStats.rangedProtection
				local rangedProt = rangedProtection.Value * 0.01
				local finalArmorValue = 1 - ( (rangedProt) * (1 - armorPenetration) )


				-- Applies durability changes
				local durability = child.toolStats.durability
				durability.Value -= damage


				damage = damage * finalArmorValue -- Damage here is still base damage not multiplied


				if hit.Name == "plrBodyHitbox" or hit.Name == "UpperTorso" or hit.Name == "LowerTorso" or hit.Name == "HumanoidRootPart" or hit.Name == "LeftHand" or hit.Name == "RightHand" or hit.Name == "LeftUpperArm" or hit.Name == "RightUpperArm" or hit.Name == "LeftLowerArm" or hit.Name == "RightLowerArm" then

					hum:TakeDamage(damage)

				elseif hit.Name == "plrHeadHitbox" or hit.Name == "Head" then

					hum:TakeDamage(damage)

				else

					hum:TakeDamage(damage)

				end

			end
		end

	end

    -- If There is no armor to protect the hit area
	if hasArmor == false then
		
		--print("The hit target had no:".. hitArmor)
		
		if hit.Name == "plrBodyHitbox" or hit.Name == "UpperTorso" or hit.Name == "LowerTorso" or hit.Name == "HumanoidRootPart" or hit.Name == "LeftHand" or hit.Name == "RightHand" or hit.Name == "LeftUpperArm" or hit.Name == "RightUpperArm" or hit.Name == "LeftLowerArm" or hit.Name == "RightLowerArm" then

			hum:TakeDamage(damage * 1)

		elseif hit.Name == "plrHeadHitbox" or hit.Name == "Head" then

			hum:TakeDamage(damage * 1)

		else

			hum:TakeDamage(damage)

		end

	end

end



local function attack(npc, npcType)

	local hum = npc.Humanoid
	
	if npc.db.Value == true then

		task.wait(npcTable[npcType.Value].attackCooldown)
		npc.db.Value = false

		return
	end -- If it hasn't finished cooldown yet


	local weapon = npc:FindFirstChildOfClass("Tool")

	if weapon == nil then return end
	
	local weaponHitbox = weapon.Handle

	local attackTrack = hum.Animator:LoadAnimation(weapon.attackAnimation)

	if attackTrack then
		attackTrack:Play()
	end
	
	playSoundServer:Fire(weapon.attackSound, weapon)
	--attackTrack:AdjustSpeed(npcTable[npcType.Value].attackAnimSpeedAdjust)


	weaponHitbox.Touched:Connect(function(hit)
		
		if npc.db.Value == true then return end

		if hit.Parent:FindFirstChild("Humanoid") == nil then return end -- Attack didn't hit a human

		if hit.Parent == npc then return end -- If the npc hit themselves

		npc.db.Value = true

		playSoundServer:Fire(weapon.hitSound, weapon)

		local hum = hit.Parent:FindFirstChild("Humanoid")
		
		hum:TakeDamage(npcTable[npcType.Value].bluntDamage)
		hum:TakeDamage(npcTable[npcType.Value].bladeDamage)

	end)

	wait(npcTable[npcType.Value].attackCooldown)

	npc.db.Value = false

end



local function escape(npc, npcType)
	
	local hum = npc:FindFirstChild("Humanoid", 1)
	if hum then
		if hum.Health <= 0 then return end
	elseif hum == nil then
		despawn(npc, 3)
	end
	
	local state = npc:FindFirstChild("state", 1)
	local root = npc:FindFirstChild("HumanoidRootPart", 1)

	local movementAnim = npcTable[npcType.Value].priorities[state.Value][3]
	local movementTrack = hum.Animator:LoadAnimation(movementAnim)


	local possibleEscapes = npcTable[npcType.Value].escapes

	local closestPoint = nil
	local shortestDistance = 999999

	-- Set speed and animation
	local movementAnim = npcTable[npcType.Value].priorities[state.Value][3]
	local movementTrack = hum.Animator:LoadAnimation(movementAnim)
	setSpeed(npc, state.Value, npcType.Value)

	for i, escape in pairs(possibleEscapes:GetChildren()) do -- Find the shortest and accessible path

		local path = pfs:CreatePath()
		path:ComputeAsync(root.Position, escape.Position)

		if path.Status == Enum.PathStatus.Success then
			local distance = (root.Position - escape.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestPoint = escape
			end
		end

	end

	local path = pfs:CreatePath() -- Escape via that path

	movementTrack:Play()

	path:ComputeAsync(root.Position, closestPoint.Position)

	for i, waypoint in pairs(path:GetWaypoints()) do
		if waypoint.Action == Enum.PathWaypointAction.Jump then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end

		hum:MoveTo(waypoint.Position)
		hum.MoveToFinished:Wait()
	end

	movementTrack:Stop()

	despawn(npc, 1)

end



local function checkForEnemies(npc, npcType)

	local root = npc.HumanoidRootPart
	local radius = npcTable[npcType.Value].detectionRadius
	local detectionParams = OverlapParams.new()
	detectionParams.FilterType = Enum.RaycastFilterType.Exclude
	detectionParams.FilterDescendantsInstances = {npc}

	local nearby = workspace:GetPartBoundsInRadius(root.Position, radius, detectionParams)

	for i, part in ipairs(nearby) do
		local character = part:FindFirstAncestorOfClass("Model")
		if character and character:FindFirstChild("Humanoid") and players:GetPlayerFromCharacter(character) then
			local plr = players:GetPlayerFromCharacter(character)
			
			if plr.playerstats.Bounty.Value >= npcTable[npcType.Value].bountyLimit then -- Looks for player with bounty
				--print("target is:".. character.Name)
				
				return character
			end

		end
	end
	
	return nil

end


local function checkState(npc, npcType)
	
	local hum = npc:FindFirstChild("Humanoid", 1)
	if hum then
		if hum.Health <= 0 then 
			despawn(npc, 3)
			return
		end
	else
		despawn(npc, 3)
	end
	
	local state = npc:FindFirstChild("state", 1)
	if state == nil then
		despawn(npc, 3)
		return
	end
	local state = npc.state
	local aggroed = npc.aggroed
	local target = npc.target
	local state = npc.state
	
	if target.Value == "none" then -- Looks for an enemy when there is no target only
		local enemy = checkForEnemies(npc, npcType)

		if enemy then

			target.Value = enemy.Name
			aggroed.Value = true
			state.Value = "attack"

		end
	end
	

	
	if target.Value ~= "none" then
		local targetPlr = game.Players:FindFirstChild(target.Value, 1)
		
		if targetPlr == nil then
			aggroed.Value = false
			target.Value = "none"
			state.Value = "patrol"
		end
	end

	if hum.Health <= npcTable[npcType.Value].escapeRequirement then
		state.Value = "escape"
		escape(npc, npcType)
	elseif npc.aggroed.Value == true then
		state.Value = "attack"
	else
		state.Value = "patrol"
	end

end


local function canSeeEnemy(char, npcType, targetChar)
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {char:GetChildren()}
	
	local origin = char.Head.Position
	local direction = (targetChar.HumanoidRootPart.Position - origin).unit * 1000
	
	local results = workspace:Raycast(origin, direction, params)
	
	if results then
		
		local part = results.Instance
		
		if part.Parent == targetChar then -- If the parent of the hit part is the character then the npc can see the enemy
			return true -- Can see enemy
		else
			return false -- Cannot see enemy
		end
		
	end
	
end


local function pathfindTo(char, npcType, position, isChase)	
	
	
	
	local hum = char:FindFirstChild("Humanoid")
	if not hum then return end
	
	local state = char.state
	local root = char.HumanoidRootPart
	
	local path = pfs:CreatePath()
	path:ComputeAsync(root.Position, position)

	checkState(char, npcType)


	for i, waypoint in pairs(path:GetWaypoints()) do
		
		if hum.Health <= npcTable[npcType.Value].escapeRequirement then
			state.Value = "escape"

			break
		end
		
		if waypoint.Action == Enum.PathWaypointAction.Jump then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		
		if hum.Sit == true then 
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		
		checkState(char, npcType)
		
		if isChase == false and state.Value ~= "patrol" then -- If the objective is not chasing and the state exits patroling
			break
		end
		
		if isChase then -- Special logic, in case when npc is chasing a player
			
			if char.target.Value == "none" then break end
			
			local target = game.Players[char.target.Value] -- Gets the player
			if target == nil then break end
			
			local targetChar = target.Character
			
			local inRange = false
			
			-- If the character is in 80% of attack range from npc
			if (char.HumanoidRootPart.Position - targetChar.HumanoidRootPart.Position).Magnitude <= 0.8 * npcTable[npcType.Value].attackRange then
				
				inRange = true
				
			end
			
			-- If all criterias are fulfilled, then stop chasing
			-- Criterias:
			-- Player is in range
			-- The player can be seen by the npc
			if inRange == true and canSeeEnemy(char, npcType, targetChar) then
				break
			end
			
		end

		hum:MoveTo(waypoint.Position)
		hum.MoveToFinished:Wait()
	end
	
end



local function gunShoot(char, npcType, gun, target)
	
	local ADSTrack = char.Humanoid.Animator:LoadAnimation(gun.ADS)
	ADSTrack:Play()
	
	checkState(char, npcType)
	
	task.spawn(function()
		
		task.wait(10)
		
		ADSTrack:Stop()
		
	end)
	
	if gun.toolStats.ammoLeft.Value > 0 then
		
		
		playSoundServer:Fire(gun.fireSound, gun)
		
		local fire = char.Humanoid.Animator:LoadAnimation(gun.fire)
		fire:Play()
		
		gun.toolStats.ammoLeft.Value -= 1

		local params =  RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {char:GetChildren(), gun:GetChildren()}
		params.IgnoreWater = true
		
		
		local targetPlr = game.Players[target.Value]
		local origin = gun.Handle.Position
		local distance = (targetPlr.Character.UpperTorso.Position - origin).Magnitude
		
		local spreadX = ((math.random(0 - npcTable[npcType.Value].rangedSpread, npcTable[npcType.Value].rangedSpread) / 10000) * distance)
		local spreadY = ((math.random(0 - npcTable[npcType.Value].rangedSpread, npcTable[npcType.Value].rangedSpread) / 10000) * distance)
		local spreadZ = ((math.random(0 - npcTable[npcType.Value].rangedSpread, npcTable[npcType.Value].rangedSpread) / 10000) * distance)
		local spread = Vector3.new(spreadX, spreadY, spreadZ)
		
		local direction = (targetPlr.Character.UpperTorso.Position - origin + spread).unit * 1000

		
		local raycastDirection = (direction) * 1000
				
		local results = workspace:Raycast(origin, raycastDirection, params) -- 1000 is the range of the ray
		local hit = false
		local recast = false
		
		checkState(char, npcType)

		if results then
			local part = results.Instance
			if part.Name == "Handle" or part.Parent == gun then return end
			local hitChar = part:FindFirstAncestorOfClass("Model")
			
			createTracer(origin, results.Position) -- Creates the tracer

			
			if hitChar and hitChar:FindFirstChild("Humanoid") and hitChar ~= char then
				
				if hit == true then return end
				hit = true
				local hum = hitChar:FindFirstChild("Humanoid")
				
				applyDamage(char, npcType, part, hum, char, "ranged")
				
			else -- Didn't hit anything, so the NPC needs to adjust position
				
				local bulletHole = Instance.new("Part") -- Makes a bullet hole if didn't hit anything
				bulletHole.Name = "bulletHole"
				bulletHole.Anchored = true
				bulletHole.Size = Vector3.new(0.1, 0.1, 0.1)
				bulletHole.BrickColor = BrickColor.new("Black metallic")
				bulletHole.CanQuery = false
				bulletHole.CanCollide = false
				bulletHole.CanTouch = false
				bulletHole.Parent = game.Workspace
				bulletHole.Position = results.Position
				

				game.Debris:AddItem(bulletHole, 10)
				
				task.wait(npcTable[npcType.Value].rangedCooldown)
				return "nothing"
				
			end
		end
		
		task.wait(npcTable[npcType.Value].rangedCooldown) -- Shooting cooldown

	else
		
		ADSTrack:Stop()
		
		local reload = char.Humanoid.Animator:LoadAnimation(gun.reload)
		reload:Play()
		reload:AdjustSpeed(npcTable[npcType.Value].reloadAdjust)
		
		playSoundServer:Fire(gun.reloadSound, gun)
		
		checkState(char, npcType)
		
		task.wait(npcTable[npcType.Value].reloadTime)
		
		gun.toolStats.ammoLeft.Value = gun.maxAmmo.Value
		
		return
		
	end
	
end


-- Logic for when NPC spawns

function module.start(char, npcType)
	
	setCollisionGroup(char)
	
	local hum = char.Humanoid
	local state = char.state
	local root = char.HumanoidRootPart
	local aggroed = char.aggroed
	local target = char.target
	local isHitman = char.isHitman -- If the character will despawn after the target dies
	
	root:SetNetworkOwner(nil)	

	local patrolAnim = npcTable[npcType.Value].priorities["patrol"][3]
	local aggroAnim = npcTable[npcType.Value].priorities["attack"][3]
	local patrolTrack = hum.Animator:LoadAnimation(patrolAnim)
	local aggroTrack = hum.Animator:LoadAnimation(aggroAnim)
	
	local gun = nil
	
	if npcTable[npcType.Value].attackMethod == "ranged" then
		gun = char:FindFirstChildOfClass("Tool")
		
		local idleTrack = hum.Animator:LoadAnimation(gun.Idle)
		local ADSTrack = hum.Animator:LoadAnimation(gun.ADS)
		local Hipfire = hum.Animator:LoadAnimation(gun.Hipfire)
		local fire = hum.Animator:LoadAnimation(gun.fire)
		local reload = hum.Animator:LoadAnimation(gun.reload)	
		
		idleTrack:Play()
		
	end
	
	-- Handles NPC death
	hum.Died:Once(function()
		
		-- Ensures the amount of wads of cash dropped won't exceed the kill reward		
		local cashValue = 0
		local count = 0
		
		while char.killReward.Value > 0 and count < MAX_CASH_MODELS_DROP do
			cashValue = math.random(1, char.killReward.Value)
			char.killReward.Value -= cashValue
			
			local cash = cashModel:Clone()
			cash:SetAttribute("cronsValue", cashValue)
			cash.Parent = game.Workspace
			cash.CFrame = root.CFrame * CFrame.new(0, 2, 0)
			
			count += 1
		end
		
		if count >= MAX_CASH_MODELS_DROP then
			local cash = cashModel:Clone()
			cash:SetAttribute("cronsValue", char.killReward.Value)
			cash.Parent = game.Workspace
			cash.CFrame = root.CFrame * CFrame.new(0, 2, 0)
		end
		
		despawn(char, 3)
		
		--R15(char)
		--setNetworkOwner(char)
		
	end)
	
	
	-- Runs the code for the first time
	if target.Value == "none" then
		
		if isHitman.Value == true then
			despawn(char, 7)
		end
		
		aggroed.Value = false
		state.Value = "patrol"

	else 	-- If there's a new target

		local plr = game.Players[target.Value]

		local character = plr.Character -- Gets the player character safely
		if not char then
			local success
			success, char = pcall(function()
				return plr.CharacterAdded:Wait()
			end)
		end

		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid == nil then return end

		humanoid.Died:Connect(function()

			target.Value = "none"
			aggroed.Value = false
			state.Value = "patrol"

			if isHitman.Value == true then -- Despawns the NPC if its a hitman type NPC after target dies

				despawn(char, 7)

			end

		end)

	end
	
	
	-- Checks for one time behaviour changes when state changes
	state:GetPropertyChangedSignal("Value"):Connect(function()

		if state.Value == "patrol" then
			
			-- Deletes the tool (Unequips it)
			if npcTable[npcType.Value].onlyEquipWhenAggro == true then
				local tool = char:FindFirstChildOfClass("Tool")
				
				if tool then
					tool:Destroy()
				end
			end
			
		elseif state.Value == "attack" then
			
			-- Equips the tool
			if npcTable[npcType.Value].onlyEquipWhenAggro == true then
				
				local cloneTool = npcTable[npcType.Value].weapon:Clone()
				cloneTool.Parent = char
				
			end
			
		elseif state.Value == "escape" then
			
			-- Deletes the tool (Unequips it)
			if npcTable[npcType.Value].onlyEquipWhenAggro == true then
				local tool = char:FindFirstChildOfClass("Tool")

				if tool then
					tool:Destroy()
				end
			end
		end
		
	end)
	
	
	-- Looks for target
	target:GetPropertyChangedSignal("Value"):Connect(function() 
		
		if target.Value == "none" then
			
			if isHitman.Value == true then
				despawn(char, 7)
			end
			
			aggroed.Value = false
			state.Value = "patrol"
			
		else 	-- If there's a new target
			
			local plr = game.Players[target.Value]
			
			local character = plr.Character -- Gets the player character safely
			if not char then
				local success
				success, char = pcall(function()
					return plr.CharacterAdded:Wait()
				end)
			end
			
			local humanoid = character:FindFirstChild("Humanoid")
			
			if humanoid == nil then return end
			
			humanoid.Died:Connect(function()
				
				target.Value = "none"
				aggroed.Value = false
				state.Value = "patrol"
				
				if isHitman.Value == true then -- Despawns the NPC if its a hitman type NPC after target dies
					
					despawn(char, 7)
					
				end

			end)
			
		end
		
	end)
	
	
	task.spawn(function() -- Logic for talking
		
		while hum.Health > 0 do
			
			task.wait(npcDialogue[npcType.Value].cooldown)
			npcTalk(char, npcType, nil)
			
		end
		
	end)


	task.spawn(function() -- Starts the main logic
		
		while hum.Health > 0 do

			task.wait()

			checkState(char, npcType)

			if state.Value == "patrol" then -- Patroling
				-- Set animation and speed				
				
				patrolTrack:Stop()

				setSpeed(char, state.Value, npcType.Value)
				
				
				-- STAYING IN THE PATROL POINT
				for i = npcTable[npcType.Value].stayTime , 0, -0.1 do -- Stays in the patrol point
					checkState(char, npcType)

					if state.Value ~= "patrol" then 

						break  -- Breaks if no longer in patrol mode (such as being attacked)
						
					end 
					wait(0.1)

				end
				
				
				-- ROTATING TO THE NEXT PATROL POINT
				if npcTable[npcType.Value].randomPatrols == true then -- If the NPC can go to any random patrol point
					
					patrolTrack:Play()
					patrolTrack:AdjustSpeed(0.4)
					
					while state.Value == "patrol" do
						
						patrolTrack:Play()
						patrolTrack:AdjustSpeed(0.4)
						
						
						-- Chooses a random patrol point to go to
						local randomPoint = npcTable[npcType.Value].patrolPoints:GetChildren()[math.random(1, #npcTable[npcType.Value].spawnPoints:GetChildren())]
					
						
						randomPoint:SetAttribute("taken", true) -- Sets the taken flag as true
						
						
						pathfindTo(char, npcType, randomPoint.Position, false)
						
						
						patrolTrack:Stop()
						
						for i = npcTable[npcType.Value].stayTime, 0, -0.1 do -- Stays in the patrol point
							checkState(char, npcType)

							if state.Value ~= "patrol" then 

								break  -- Breaks if no longer in patrol mode (such as being attacked)

							end 
							wait(0.1)

						end
						
						randomPoint:SetAttribute("taken", false) -- Sets the taken flag as false once patrolling and staying finished
						
					end
					
				else -- If the NPC has a set patrol order
					
					for i, point in pairs(npcTable[npcType.Value].patrolPoints:GetChildren()) do
						
						patrolTrack:Play()
						patrolTrack:AdjustSpeed(0.4)
						
						-- Skips this waypoint if the point is already taken
						if point:GetAttribute("taken") == true then
							continue
						end
						
						point:SetAttribute("taken", true)
						
						pathfindTo(char, npcType, point.Position, false)
						
						patrolTrack:Stop()

						for i = npcTable[npcType.Value].stayTime, 0, -0.1 do
							checkState(char, npcType)

							if state.Value ~= "patrol" then 
								break 
							end 
							wait(0.1)

						end
						
						point:SetAttribute("taken", false) -- Sets the taken flag as false once patrolling and staying finished


					end
					
				end
				

			elseif aggroed.Value == true then -- aggroed
				-- Set animation and speed
				
				local distance = (root.Position - game.Players[target.Value].Character.HumanoidRootPart.Position).Magnitude

				task.wait()

				if game.Players[target.Value].Character.Humanoid.Health <= 0 then
					aggroed.Value = false
					target.Value = "none"
					state.Value = "patrol"
				end

				local targetPlr = game.Players[target.Value]
				local targetChar = targetPlr.Character

				-- If the player is in range and can be seen then attack
				if distance <= npcTable[npcType.Value].attackRange and canSeeEnemy(char, npcType, targetChar) then
					-- Set animation and speed
					
					local npcRoot = char.HumanoidRootPart -- Looks at the player

					local targetPos = targetChar.HumanoidRootPart.Position
					local npcPos = npcRoot.Position
					
					local lookPos = Vector3.new(targetPos.X, npcPos.Y, targetPos.Z)

					
					npcRoot.CFrame = CFrame.lookAt(npcRoot.Position, lookPos)
					
					if npcTable[npcType.Value].attackMethod == "melee" then

						aggroTrack:Stop()
						attack(char, npcType)

					elseif npcTable[npcType.Value].attackMethod == "ranged" then

						aggroTrack:Stop()
						if gunShoot(char, npcType, gun, target) == "nothing" then -- If enemy is no longer in range, continue
							
							aggroTrack:Play()
							
							continue
							
							--local point = game.Players[target.Value].Character.HumanoidRootPart
							--pathfindTo(char, npcType, point.Position, true)
						end

					end


				else -- Otherwise chase the player

					checkState(char, npcType)

					aggroTrack:Play()
					aggroTrack:AdjustSpeed(0.4)
					
					setSpeed(char, state.Value, npcType.Value)

					local point = game.Players[target.Value].Character.HumanoidRootPart
					local targetPlr = game.Players[target.Value]
					local targetChar = targetPlr.Character
										
					pathfindTo(char, npcType, targetChar.HumanoidRootPart.Position, true)
					
					aggroTrack:Stop()

				end

			end


		end
		
		despawn(char, 3)
		
	end)
	
end

return module
