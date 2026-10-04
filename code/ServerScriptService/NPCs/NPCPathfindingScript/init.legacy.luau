local pfs = game:GetService("PathfindingService")
local serverStorage = game:WaitForChild("ServerStorage")
local collectionService = game:GetService("CollectionService")


local escapes = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").escapePoints
local spawns = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").spawnPoints
local patrols = game:WaitForChild("Workspace"):WaitForChild("NPCWaypoints").patrolPoints -- The points for this NPC
local stayTime = 10

local serverScriptService = game.ServerScriptService

local npcLogic = require(serverScriptService.moduleScripts.npcLogic)


for v, char in pairs (collectionService:GetTagged("npc")) do -- Starts the npc logic for all npcs
	
	local hum = char:WaitForChild("Humanoid")
	local root = char.HumanoidRootPart
	
	local state = char.state
	local target = char.target
	local npcType = char.npcType
	local aggroed = char.aggroed
	
	npcLogic.start(char, char.npcType)
	
end

collectionService:GetInstanceAddedSignal("npc"):Connect(function(char) -- Starts the npc logic for all newly added npcs
	local hum = char:WaitForChild("Humanoid")
	local root = char.HumanoidRootPart

	local state = char.state
	local target = char.target
	local npcType = char.npcType
	local aggroed = char.aggroed

	npcLogic.start(char, char.npcType)
end)
