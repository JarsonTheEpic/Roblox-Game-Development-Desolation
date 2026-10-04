local dss = game:GetService("DataStoreService")
local inventoryStore = dss:GetDataStore("Inventory")
local httpService = game:GetService("HttpService")
local customisationStore = dss:GetDataStore("customisationStore")
local ammoStore = dss:GetDataStore("ammoStore")
local gameStatStore = dss:GetDataStore("gameStatStore")
local statStore = dss:GetDataStore("statStore")

local bannedTools = {
	"Fists",
	"Wallet",
	"Phone",
	"Key",
	"Supply box"
}

local exampleTool = { -- This is only an example, it is not used
	"Name",
	{
		ammo = "23",
		durability = "49"
	}
}

local plrChars = { -- The list that stores player characters, used when player leaves
	
}

local function resetHouses(plr)

	for i, tool in plr.Backpack:GetChildren() do

		if tool.Name == "Key" then

			local linkedDoor = tool.linkedDoor.Value
			local buyPart = linkedDoor.salePart
			
			buyPart.SurfaceGui.TextLabel.Text = "For rent"
			buyPart.buyHousePrompt.Enabled = true
			buyPart.Parent.Locked.Value = true

		end

	end

end


local function deathFunction(plr, char)
	
	print("Player death")
	inventoryStore:SetAsync(plr.UserId, "[]")

	if char:FindFirstChildOfClass("Tool") then
		char:FindFirstChildOfClass("Tool").Parent = plr.Backpack
	end

	plr.ownedProperties.Value = 0
	resetHouses(plr)

	if char:FindFirstChildOfClass("Tool") then
		char:FindFirstChildOfClass("Tool"):Destroy()
	end

	plr.Backpack:ClearAllChildren() -- Deletes all the player's tools

	plr.canSaveData.Value = false
	
	plr.extrastats.daysSurvived.Value = 0
	plr.ownedProperties.Value = 0
	
	-- Ammo stats
	local plrAmmo = plr.plrAmmo

	local a556 = plrAmmo.a556x45mm
	a556.Value = 0

	local a9x18 = plrAmmo.a9x18mm
	a9x18.Value = 0

	local a338Lapua = plrAmmo.a338Lapua
	a338Lapua.Value = 0

	local a762 = plrAmmo.a762x39mm
	a762.Value = 0

	local a45Auto = plrAmmo.a45Auto
	a45Auto.Value = 0

	--Player stats

	local playerstats = plr.playerstats
	playerstats.Name = "playerstats"
	playerstats.Parent = plr

	local charisma = playerstats.Charisma
	charisma.Value = 10

	local stamina = playerstats.Stamina
	stamina.Value = 100

	local sanity = playerstats.Sanity
	sanity.Value = 100

	local hygiene = playerstats.Hygiene
	hygiene.Value = 100

	local saturation = playerstats.Saturation
	saturation.Value = 100

	local hydration = playerstats.Hydration
	hydration.Value = 100

	local occupation = playerstats.Occupation
	occupation.Value = "Unemployed"

	local bounty = playerstats.Bounty
	bounty.Value = 0

	-- Armor name values

	local helmet = playerstats.Helmet
	helmet.Value = "None"

	local vest = playerstats.Vest
	vest.Value = "None"

	local leggings = playerstats.Leggings
	leggings.Value = "None"

	local armor = char.Armor

	helmet = armor.Helmet
	helmet.Value = "None"

	vest = armor.Vest
	vest.Value = "None"

	leggings = armor.Vest
	leggings.Value = "None"



	if char:FindFirstChildOfClass("Tool") then
		char:FindFirstChildOfClass("Tool").Parent = plr.Backpack
	end

	resetHouses(plr)

	if char:FindFirstChildOfClass("Tool") then
		char:FindFirstChildOfClass("Tool"):Destroy()
	end

	plr.Backpack:ClearAllChildren()
	
	plr.canSaveData.Value = false
	
end


game.Players.PlayerAdded:Connect(function(plr)
	
	local inventory

	local success, errorMessage = pcall(function()
		inventory = httpService:JSONDecode(inventoryStore:GetAsync(plr.UserId))
	end)
	
	print(inventory)
	
	local invFolder = Instance.new("Folder")
	invFolder.Name = "Inventory"
	invFolder.Parent = plr
	
	repeat task.wait() until plr.Backpack
	repeat task.wait() until plr.Character
	task.wait(1)
	
	-- Loads the players tools
	if inventory then
		for i, tool in inventory do
			-- if bannedTools[tool[i]] then continue end
			
			local newTool = game.ServerStorage.Tools:FindFirstChild(tool[1], true):Clone()
			
			--print(newTool)

			local canAdd = true
			for j, banned in bannedTools do
				if banned[1] == tool[1] then
					canAdd = false
				end
			end

			if newTool.Name ~= "Wallet" and newTool.Name ~= "Fists" and newTool.Name ~= "Phone" and newTool ~= "Key" then 

				--print(newTool.Name)
				if newTool:FindFirstChild("toolStats") then

					for j, stat in newTool.toolStats:GetChildren() do
						for m, checkStat in tool[2] do
							if checkStat[1] == stat.Name then
								stat.Value = checkStat[2]
							end
						end
					end

				end
				newTool.Parent = plr.Backpack
			end
		end
	end
	
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	plrChars[plr.Name] = char -- Adds the character to the list

	
	local hum = char:WaitForChild("Humanoid")
	
	hum.Died:Connect(function() -- Death
		deathFunction(plr, char)
	end)

	
	plr.CharacterAdded:Connect(function(char)
		
		plr.inCombat.Value = false
		plr.canSaveData.Value = true
		local hum = char:WaitForChild("Humanoid")
		
		hum.Died:Connect(function() -- Death
			deathFunction(plr, char)
		end)
	end)
	
	
	plr.CharacterRemoving:Connect(function(char)	-- When the player leaves or dies
		
		plrChars[plr.Name] = char
		
		if char:FindFirstChildOfClass("Tool") then
			local tool = char:FindFirstChildOfClass("Tool")
			tool.Parent = plr.Backpack
			
			resetHouses(plr)
		end
	end)
	
	--plr.Character.ChildAdded:Connect(function(child)
	--	if child:IsA("Tool") == true then
	--		local dupeTool = child:Clone()
	--		dupeTool.Parent = plr
	--	end
	--end)
	
	--plr.Character.ChildRemoved:Connect(function(child)
	--	if child:IsA("Tool") == true then
	--		for i, tool in plr:GetChildren() do
	--			if tool:IsA("Tool") == true and tool.Name == child.Name then
	--				tool:Destroy()
	--			end
	--		end
	--	end
	--end)
	
end)

game.Players.PlayerRemoving:Connect(function(plr)
	
	local invTable = {}

	for i, child in pairs(plr.Backpack:GetChildren()) do
		
		for j, banned in bannedTools do
			if child.Name == banned then
				child:Destroy()
			end
		end
		
	end
	
	
	-- If the player leaves while in combat, it won't save their game stats
	if plr.inCombat.Value == true then
		print("Didnt save tools due to combat leave")
		
		deathFunction(plr, plrChars[plr.Name])
		
		return
	end
	
	if plr.canSaveData.Value == false then
		print("Cannot save data")
		
		deathFunction(plr, plrChars[plr.Name])

		return
	end
	
	-- Stores the player's tools along with their toolstats
	for i, child in plr.Backpack:GetChildren() do
		print("Saved player data")
		if child:FindFirstChild("toolStats") then
			local tool = {child.Name,
				{}
			}
			for i, stat in child.toolStats:GetChildren() do
				
				table.insert(tool[2], {stat.Name, stat.Value})
				
			end
			
			table.insert(invTable, tool)
		else
			table.insert(invTable, {
				child.Name,
				{}
			})
		end
	end
	
	local invData = httpService:JSONEncode(invTable)
	inventoryStore:SetAsync(plr.UserId, invData)
	
	resetHouses(plr)
	
end)