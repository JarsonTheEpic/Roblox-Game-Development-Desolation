local pfs = game:GetService("PathfindingService")
local serverStorage = game:WaitForChild("ServerStorage")
local collectionService = game:GetService("CollectionService")


local escapes = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").escapePoints
local spawns = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").spawnPoints
local patrols = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").patrolPoints -- The points for this NPC

local serverScriptService = game.ServerScriptService

repeat task.wait() until serverScriptService.moduleScripts.npcLogic

local npcLogic = require(serverScriptService.moduleScripts.npcLogic)
local npcModels = game:WaitForChild("ServerStorage").npcModels
local npcOriginalSpawn = game:WaitForChild("Workspace"):WaitForChild("Cameras").npcOriginalSpawn


local npcTable = {
	Civillian = {
		type = "Civillian",
		maxHealth = 100,
		health = 100,
		maxCount = 8,
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
		weapon = serverStorage.Tools.Melees.Fists,
		spawnPoints = spawns.Civillian,
		randomPatrols = true,
		respawnTime = 10,
		bountyLimit = math.huge, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 60,
		amount = 2,
		spawnInterval = 3,

		killRewardMin = 0,
		killRewardMax = 50,
		killRewardModels = 2
	},
	
	Civillian2 = {
		type = "Civillian2",
		maxHealth = 100,
		health = 100,
		maxCount = 10,
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
		weapon = serverStorage.Tools.Melees["Kitchen knife"],
		spawnPoints = spawns.Civillian,
		randomPatrols = true,
		respawnTime = 5,
		bountyLimit = math.huge, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 60,
		amount = 2,
		spawnInterval = 3,

		killRewardMin = 10,
		killRewardMax = 75,
		killRewardModels = 2
	},

	Villager1 = {
		type = "Villager1",
		maxHealth = 100,
		health = 100,
		maxCount = 5,
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
		weapon = serverStorage.Tools.Melees.Fists,
		spawnPoints = spawns.Villager1,
		randomPatrols = true,
		respawnTime = 15,
		bountyLimit = math.huge, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 60,
		amount = 1,
		spawnInterval = 3,

		killRewardMin = 0,
		killRewardMax = 50,
		killRewardModels = 2
	},

	villageGuard1 = {
		type = "villageGuard1",
		maxHealth = 150,
		health = 150,
		maxCount = 4,
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

		rangedDamage = 25,
		rangedPenetration = 0.15,
		rangedSpread = 800,
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
		spawnPoints = spawns.villageGuard1,
		randomPatrols = false,
		respawnTime = 30,
		bountyLimit = 10, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 80,
		amount = 1,
		spawnInterval = 3,

		killRewardMin = 0,
		killRewardMax = 50,
		killRewardModels = 2
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

		spawnPoints = spawns.policePistol,
		randomPatrols = false,
		respawnTime = 30,
		bountyLimit = 50, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 80,
		amount = 2, -- The amount of this NPC that spawns each time
		spawnInterval = 3,

		maxPerPlayer = 4, -- The maximum amount of this type of NPC that can attack one player at one time
		
		killRewardMin = 0,
		killRewardMax = 0,
		killRewardModels = 2
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

		spawnPoints = spawns.policePistol,
		randomPatrols = false,
		respawnTime = 30,
		bountyLimit = 300, -- When a players bounty reaches this or above the npc will target them
		detectionRadius = 80,
		amount = 2, -- The amount of this NPC that spawns each time
		spawnInterval = 3,

		maxPerPlayer = 4, -- The maximum amount of this type of NPC that can attack one player at one time

		killRewardMin = 0,
		killRewardMax = 0,
		killRewardModels = 2
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

		rangedDamage = 15,
		rangedPenetration = 0.4,
		rangedSpread = 1000,
		rangedCooldown = 0.35,
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
		amount = 1,
		spawnInterval = 3,
		
		killRewardMin = 0,
		killRewardMax = 100,
		killRewardModels = 4
	}
}


-- Tracks whether each NPC can spawn or not, so each NPC doesn't interfere with spawning of other NPCs
local npcRespawnTable = {

}


for i, npcGroup in pairs (npcTable) do

	npcRespawnTable[npcGroup.type] = true

end


local function despawn(npc, timer)	
	if timer == nil then timer = 0 end

	task.wait(timer)

	npc:Destroy()
end



local function npcCount(npcGroup, targetName, npcName) -- Use npc name if assigning a specific target
	
	-- Counts the amount of npcs for a specific group
	local count = 0
	
	if targetName then -- If a specifc target is given
		for i, npc in pairs (collectionService:GetTagged("npc")) do

			if npc.Name == npcName and npc.target.Value == targetName then

				count += 1

			end		

		end
		
	else
		
		for i, npc in pairs (collectionService:GetTagged("npc")) do

			if npc.npcType.Value == npcGroup.type then

				count += 1

			end		

		end
		
	end
	
	
	
	return count
	
end



local function validSpawnPoints(npcGroup, pos) -- Checks and returns all close enough spawn points to the given position (within spawnMaximumRange)
	
	local validPoints = {}
	
	for i, point in pairs(npcGroup.spawnPoints:GetChildren()) do
		
		if (pos - point.Position).Magnitude <= npcGroup.spawnMaximumRange then
			
			table.insert(validPoints, point)
			
		end
		
	end
	
	return validPoints
	
end



local function spawnNPC(npcGroup, position, spawnTime, target, isHitman, amount)
	
	-- Disables spawning for this type of npc temporarily
	npcRespawnTable[npcGroup.type] = false
	local interval = npcTable[npcGroup.type].spawnInterval
	
	task.spawn(function()
		
		task.wait((amount - 1) * interval + spawnTime)
		npcRespawnTable[npcGroup.type] = true
		
	end)
	
	task.spawn(function()
		
		for i = 0, amount, 1 do
			-- Spawns NPCs accordingly to the amount
			
			if npcCount(npcGroup) >= npcGroup.maxCount then return end

			if isHitman then
				
				if npcCount(npcGroup, target.Name, npcGroup.type) >= npcGroup.maxPerPlayer then continue end

			end


			local npcType = npcGroup.type -- Spawns the npc first, before actually putting it on the map
			local npc = npcModels[npcType]:Clone()

			-- Randomly customises the npc
			npc:FindFirstChildOfClass("Pants"):Destroy() -- Gives the npc a random pair of pants
			local newPants = npc.Pants:GetChildren()[math.random(1, #npc.Pants:GetChildren())]
			newPants.Parent = npc

			npc:FindFirstChildOfClass("Shirt"):Destroy() -- Gives the npc a random shirt
			local newShirt = npc.Shirts:GetChildren()[math.random(1, #npc.Shirts:GetChildren())]
			newShirt.Parent = npc


			npc:MoveTo(npcOriginalSpawn.Position)
			npc:AddTag("npc")

			if target then -- If the npc is assigned a target

				npc.aggroed.Value = true
				npc.state.Value = "attack"
				npc.target.Value = target.Name

			end

			
			-- Sets npc values
			npc.isHitman.Value = isHitman
			npc.killReward.Value = math.random(npcGroup.killRewardMin, npcGroup.killRewardMax)
			
			-- If its the first NPC to spawn in a group then wait the normal amount of time
			if i == 0 then
				task.wait(spawnTime)
				--print(spawnTime)
			else
				-- Otherwise wait only the spawn interval
				task.wait(interval)
				print(interval)
			end

			local root = npc.HumanoidRootPart

			if position == nil then -- If there's no specifed spawn position
				local randomSpawn = npcGroup.spawnPoints:GetChildren()[math.random(1, #npcGroup.spawnPoints:GetChildren())]

				root.Position = randomSpawn.Position
				npc.Parent = game.Workspace

			else
				root.Position = position
				npc.Parent = game.Workspace

			end	
		end
	end)	
end


while true do
	
	for i, npcGroup in pairs (npcTable) do
		
		if not npcGroup.canSpawnNaturally then -- Non naturally spawning npcs
			
			for i, plr in pairs(game.Players:GetChildren()) do -- Checks through all the players to see if their bounty is enough
				
				
				local char = plr.Character -- Gets the player character safely
				if not char then
					local success
					success, char = pcall(function()
						return plr.CharacterAdded:Wait()
					end)
				end
				
				if not char then
					continue
				end
				
				
				local root = char:WaitForChild("HumanoidRootPart", 3)
				if not root then continue end
				
				-- Finds a valid spawn point
				local spawnPoints = validSpawnPoints(npcGroup, root.Position)

				if plr.playerstats.Bounty.Value >= npcGroup.bountyLimit	and npcCount(npcGroup, plr.Name, npcGroup.type) < npcGroup.maxPerPlayer and npcRespawnTable[npcGroup.type] then
					
					if #spawnPoints == 0 then 
						continue
					end  -- If there are no valid spawns#
					
					local randomSpawn = spawnPoints[math.random(1, #spawnPoints)]

					spawnNPC(npcGroup, randomSpawn.Position, npcGroup.respawnTime, plr, true, npcGroup.amount)
					
				end
				
			end
			
		elseif npcCount(npcGroup) < npcGroup.maxCount and npcRespawnTable[npcGroup.type] then -- Naturally spawning npcs, limited by maxCount
			
			spawnNPC(npcGroup, nil, npcGroup.respawnTime, nil, false, npcGroup.amount)

		end
		
	end
	
	
	task.wait(2)
	
end
