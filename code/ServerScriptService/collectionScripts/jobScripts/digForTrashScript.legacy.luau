local collectionService = game:GetService("CollectionService")
local serverStorage = game:WaitForChild("ServerStorage")
local plrTipsEvent = game:WaitForChild("ReplicatedStorage").plrTipsEvent

local totalChance = 10000 -- Percentage is calculated by chance divided by 100

local lootTable1 = { -- The first index points to the lower chance while the second index points to the highest chance
	money100 = {0, 2000, "100 Crons", function(plr) plr.leaderstats.Crons.Value += 100 end},
	money20 = {2000, 6500, "20 Crons", function(plr) plr.leaderstats.Crons.Value += 20 end},
	nothing = {6500, 9000, "nothing"},
	shiv = {9000, 10001, "a shiv", function(plr) 
		local newShiv = serverStorage.Melees.Shiv:Clone()
		newShiv.Parent = plr.Backpack
	end}
}


for i, trash in pairs(collectionService:GetTagged("Trash")) do
	local proximityPrompt = trash.Trash.searchTrashPrompt
	local lootGroup = trash:GetAttribute("lootGroup")
	
	proximityPrompt.Triggered:Connect(function(plr)	
		local randomRoll = math.random(0, totalChance)
		
		local found = "nothing"
		local respawnTime = 60
		
		if lootGroup == 1 then
			for i, item in pairs(lootTable1) do
				
				if randomRoll >= item[1] and randomRoll < item[2] then
					found = item[3]
					local message = "You found ".. tostring(found).. "!"
									
					plrTipsEvent:FireClient(plr, message, 3)
					if item[4] then
						item[4](plr)
					end
					break
				end
				
			end
		end
		
		if lootGroup == 1 then
			respawnTime = 60
		end
		
		local newOpenSound = script.digForTrashSound:Clone()
		newOpenSound.Parent = trash.Trash
		newOpenSound:Destroy()
		
		proximityPrompt.Enabled = false
		wait(respawnTime)
		
		proximityPrompt.Enabled = true
	end)
end
