task.wait(3)
repeat task.wait() until game:FindFirstChild("ServerStorage")

local cs = game:GetService("CollectionService")

local storageSystem = game.ServerStorage.storageSystem

local baseStorage = storageSystem:Clone()
baseStorage.Name = "baseStorage"
baseStorage.Parent = game.ServerStorage

local respawningList = {}
local defaultRespawnTime = 600 -- 10 minutes to respawn


local lootGroups = {
	bedsideTable1 = {
		name = "bedsideTable1",
		minValue = 0	,
		maxValue = 10,
		items = { -- Chance of spawning is out of 1000
			canOfBeans = {
				name = "Can of beans",
				toolStats = {
					
				},
				value = 3,
				chance = 600
			},
			diamondRing = {
				name = "Diamond ring",
				toolStats = {

				},
				value = 9,
				chance = 50
			},
			makarov = {
				name = "Makarov",
				toolStats = {
					{"ammoLeft", 8},
					{"durability" , 41}				
				},
				value = 7,
				chance = 80
			},
			book = {
				name = "Book",
				toolStats = {

				},
				value = 2,
				chance = 200
			},
		}
	},
	
	bedsideTable2 = {
		name = "bedsideTable2",
		minValue = 0	,
		maxValue = 10,
		items = { -- Chance of spawning is out of 1000
			canOfBeans = {
				name = "Can of beans",
				toolStats = {

				},
				value = 3,
				chance = 600
			},
			diamondRing = {
				name = "Diamond ring",
				toolStats = {

				},
				value = 6,
				chance = 200
			},
			GCP45 = {
				name = "GCP45",
				toolStats = {
					{"ammoLeft", 12},
					{"durability" , 90}				
				},
				value = 6,
				chance = 80
			},
			book = {
				name = "Book",
				toolStats = {

				},
				value = 2,
				chance = 200
			},
			usb = {
				name = "USB",
				toolStats = {

				},
				value = 2,
				chance = 50
			},
		}
	},
	
	kitchenCounter1 = {
		name = "kitchenCounter1",
		minValue = 3,
		maxValue = 10,
		items = { -- Chance of spawning is out of 1000
			kitchenKnife = {
				name = "Kitchen knife",
				toolStats = {
					{"durability" , 40}
				},
				value = 6,
				chance = 100
			},
			canOfBeans = {
				name = "Can of beans",
				toolStats = {

				},
				value = 3,
				chance = 800
			},
			book = {
				name = "Book",
				toolStats = {

				},
				value = 5,
				chance = 300
			}
		}
	},
	
	kitchenCounter2 = {
		name = "kitchenCounter2",
		minValue = 3,
		maxValue = 10,
		items = { -- Chance of spawning is out of 1000
			kitchenKnife = {
				name = "Kitchen knife",
				toolStats = {
					{"durability" , 40}
				},
				value = 6,
				chance = 350
			},
			canOfBeans = {
				name = "Can of beans",
				toolStats = {

				},
				value = 3,
				chance = 900
			},
			diamondRing = {
				name = "Diamond ring",
				toolStats = {

				},
				value = 6,
				chance = 150
			},
		}
	},
	
	closet1 = {
		name = "closet1",
		minValue = 5,
		maxValue = 15,
		items = { -- Chance of spawning is out of 1000
			fireAxe = {
				name = "Fireaxe",
				toolStats = {
					{"durability" , 50}
				},
				value = 10,
				chance = 300
			},
			wires = {
				name = "Wires",
				toolStats = {

				},
				value = 3,
				chance = 400
			},
			AK47 = {
				name = "AK47",
				toolStats = {
					{"ammoLeft", 30},
					{"durability" , 132}				
				},
				value = 14,
				chance = 80
			},
			diamondRing = {
				name = "Diamond ring",
				toolStats = {

				},
				value = 6,
				chance = 200
			},
			book = {
				name = "Book",
				toolStats = {

				},
				value = 2,
				chance = 200
			},
			usb = {
				name = "USB",
				toolStats = {

				},
				value = 2,
				chance = 50
			},
		}
	},
	
	metalCloset1 = {
		name = "metalCloset1",
		minValue = 10,
		maxValue = 50,
		items = { -- Chance of spawning is out of 1000
			bayonet = {
				name = "Bayonet",
				toolStats = {
					{"durability" , 120}
				},
				value = 10,
				chance = 600
			},
			
			wires = {
				name = "Wires",
				toolStats = {

				},
				value = 5,
				chance = 1000
			},
			wires1 = {
				name = "Wires",
				toolStats = {

				},
				value = 5,
				chance = 600
			},
			wires2 = {
				name = "Wires",
				toolStats = {

				},
				value = 5,
				chance = 400
			}, -- Duplicate same items so they can spawn multiple times
			
			AK47 = {
				name = "AK47",
				toolStats = {
					{"ammoLeft", 30},
					{"durability" , 210}				
				},
				value = 20,
				chance = 500
			},
			ammoBox1 = {
				name = "Ammo box",
				toolStats = {
					{"a762x39mm", 90}			
				},
				value = 5,
				chance = 500
			},
			ammoBox2 = {
				name = "Ammo box",
				toolStats = {
					{"a9x18mm", 80}			
				},
				value = 5,
				chance = 500
			},
			ammoBox3 = {
				name = "Ammo box",
				toolStats = {
					{"a556x45mm", 90}			
				},
				value = 5,
				chance = 500
			},
			ammoBox4 = {
				name = "Ammo box",	
				toolStats = {
					{"a45Auto", 60}			
				},
				value = 5,
				chance = 500
			},
			
		}
		
	},
	
	metalCloset2 = {
		name = "metalCloset2",
		minValue = 5,
		maxValue = 15,
		items = { -- Chance of spawning is out of 1000
			wires = {
				name = "Wires",
				toolStats = {

				},
				value = 3,
				chance = 700
			},
			wires2 = {
				name = "Wires",
				toolStats = {

				},
				value = 3,
				chance = 550
			},
			wires3 = {
				name = "Wires",
				toolStats = {

				},
				value = 3,
				chance = 400
			}
		}
	}
}



local function respawnStorage(storage, respawnTime)
	
	task.wait(respawnTime)
	-- if the storage has a assigned folder and not in a loot group
	if storage:GetAttribute("lootGroup") == nil or storage:GetAttribute("lootGroup") == "" then
		local storage1 = baseStorage:FindFirstChild(storage.Name, 1)
		local storage2 = storageSystem:FindFirstChild(storage.Name, 1)

		for i, item in pairs(storage1:GetChildren()) do
			if storage2:FindFirstChild(item.Name) == nil then -- If the item isnt already there then add it to the storage

				local cloneItem = item:Clone()
				cloneItem.Parent = storage2
			end

		end

		for i, v in ipairs(respawningList) do
			if v == storage2.Name then
				table.remove(respawningList, i)
				break -- stop after removing it
			end
		end
		
	else	-- if the storage is in a lootgroup
		
		local lootGroup = storage:GetAttribute("lootGroup")
		
		local lootFolder = storageSystem:FindFirstChild(storage:GetAttribute("lootFolder"))
				
		local randomResult
		local value = math.random(lootGroups[lootGroup].minValue, lootGroups[lootGroup].maxValue) -- Assigns the value of this folder as a random number
		
		for i, item in pairs(lootGroups[lootGroup].items) do
			
			randomResult = math.random(1, 1000)
			if randomResult <= item.chance then -- If the result is smaller than chance then the item spawns
				
				if lootFolder:FindFirstChild(item.name) ~= nil then -- If the item already exists then don't spawn it
					continue
				end
				
				if value < item.value then -- If there is not enough value to spawn it anymore
					continue
				end
				
				value -= item.value
				
				
				local serverClone = game:WaitForChild("ServerStorage").Tools:FindFirstChild(item.name, 1):Clone()

				for i, stat in item.toolStats do -- Copies the items value to the cloned item

					serverClone.toolStats:FindFirstChild(stat[1]).Value = stat[2] -- The second index of the stats is the value

				end
				
				serverClone.Parent = lootFolder
				
			end
			
		end
		
	end
	
	storage:SetAttribute("canRespawn", true)
	
end


-- Assigns a lootFolder to every unspecified storage model (that is assigned to a loot group)
for index, storage in pairs (cs:GetTagged("storage")) do
	
	storage:SetAttribute("canRespawn", true)
	
	if storage:GetAttribute("lootGroup") == nil or storage:GetAttribute("lootGroup") == "" then
		continue
	end
	
	storage:SetAttribute("lootFolder", index)
	
	local newFolder = Instance.new("Folder")
	newFolder.Name = index
	newFolder.Parent = storageSystem
	
	task.spawn(function()
		
		respawnStorage(storage, 1) -- Respawns all loot upon the server start

	end)
	
end


while true do
	
	wait(1)

	for i, storage in pairs (cs:GetTagged("storage")) do
		
		if storage:GetAttribute("canRespawn") == true then
			--print("Respawning ".. storage.Name)
			task.spawn(function()

				storage:SetAttribute("canRespawn", false)
				respawnStorage(storage, defaultRespawnTime)

			end)
			table.insert(respawningList, storage.Name)
		end
		
	end
	
end