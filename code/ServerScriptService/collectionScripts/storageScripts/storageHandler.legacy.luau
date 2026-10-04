-- Theres a list of all storage in the game and the items in them in Server Storage
-- Loot groups define what tools a container can have, multiple containers can have the same loot group
-- If a storage doesn't have a number after its name, it will have an attribute that defines the loot group it is in
-- If it does have a number assigned to it, it will have its own folder in server storage that defines what loot it contains

local collectionService = game:GetService("CollectionService")
local openStorageScreen = game:WaitForChild("ReplicatedStorage").gameplayEvents.openStorageScreen
local takeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.takeEvent
local storeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.storeEvent
local storageSystem = game:WaitForChild("ServerStorage").storageSystem
local plrTips = game:WaitForChild("ReplicatedStorage").plrTipsEvent
local listItems = game:WaitForChild("ReplicatedStorage").gameplayEvents.listStorage



local function cloneFromServer(item) -- Takes the tool from server storage and clones it (To ensure all versions of the tool is same)
	
	local serverClone = game:WaitForChild("ServerStorage").Tools:FindFirstChild(item.Name, 1):Clone()
	
	if item:FindFirstChild("toolStats") then -- If the tool has its own stats then clones it to the ServerClone
		for i, stat in item.toolStats:GetChildren() do
			
			serverClone.toolStats:FindFirstChild(stat.Name).Value = stat.Value
			
		end
	end
	
	return serverClone
	
end


for i, storage in pairs(collectionService:GetTagged("storage")) do
	
	local storagePart = storage.storagePart
	local prompt = storagePart.storagePrompt
	
	prompt.Triggered:Connect(function(plr)
		
		openStorageScreen:FireClient(plr, storage)
		
	end)
	
end


takeEvent.OnServerEvent:Connect(function(plr, storagePoint, selectedItem)
	
	-- If the storage is specified
	if storagePoint:GetAttribute("lootGroup") == nil or storagePoint:GetAttribute("lootGroup") == "" then
		local storage = storageSystem:FindFirstChild(storagePoint.Name, 1) -- Finds the folder where the tools are stored
		local item = storage:FindFirstChild(selectedItem)

		if item then
			local serverClone = cloneFromServer(item)

			item:Destroy()
			serverClone.Parent = plr.Backpack
		else
			plrTips:FireClient(plr, "Item not found", 3)
		end

		openStorageScreen:FireClient(plr, storagePoint)

		takeEvent:FireAllClients(storagePoint)
	else
		
		local lootFolder = storageSystem:FindFirstChild(storagePoint:GetAttribute("lootFolder"))
		local item = lootFolder:FindFirstChild(selectedItem)
		
		if item then
			local serverClone = cloneFromServer(item)

			item:Destroy()
			serverClone.Parent = plr.Backpack
		else
			plrTips:FireClient(plr, "Item not found", 3)
		end
		
		openStorageScreen:FireClient(plr, storagePoint)

		takeEvent:FireAllClients(storagePoint)
		
	end
end)

storeEvent.OnServerEvent:Connect(function(plr, storagePoint, tool)
	
	if storagePoint:GetAttribute("lootGroup") == nil or storagePoint:GetAttribute("lootGroup") == "" then

		local storage = storageSystem:FindFirstChild(storagePoint.Name, 1)

		local serverClone = cloneFromServer(tool)

		tool:Destroy()
		serverClone.Parent = storage

		storeEvent:FireAllClients(storagePoint)
	else
		
		local lootFolder = storageSystem:FindFirstChild(storagePoint:GetAttribute("lootFolder"))
		
		local serverClone = cloneFromServer(tool)

		tool:Destroy()
		serverClone.Parent = lootFolder

		storeEvent:FireAllClients(storagePoint)
		
	end
	
end)



listItems.OnServerInvoke = function(plr, storagePoint) -- Returns a list of items stored
	
	if storagePoint:GetAttribute("lootGroup") == nil or storagePoint:GetAttribute("lootGroup") == "" then -- If the storage point has its own items
		
		local storageTable = {}
		for i, item in pairs(storageSystem:FindFirstChild(storagePoint.Name, 1):GetChildren()) do
			table.insert(storageTable, item.Name)
		end
		return storageTable
		
	else -- If its a generic loot group
		
		local lootFolder = storageSystem:FindFirstChild(storagePoint:GetAttribute("lootFolder"))
		
		local storageTable = {}
		for i, item in pairs(lootFolder:GetChildren()) do
			table.insert(storageTable, item.Name)
		end
		return storageTable
		
	end
	
end
