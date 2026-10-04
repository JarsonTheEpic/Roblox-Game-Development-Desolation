local dataStore = game:GetService("DataStoreService")
local customisationStore = dataStore:GetDataStore("customisationStore")
local ammoStore = dataStore:GetDataStore("ammoStore")
local gameStatStore = dataStore:GetDataStore("gameStatStore")
local statStore = dataStore:GetDataStore("statStore")

local httpService = game:GetService("HttpService")

local function refreshChar(plr)
	local char = plr:WaitForChild("Character")
	local playerstats = plr.playerstats
	local helmet = playerstats.Helmet.Value
	local vest = playerstats.Vest.Value
	local leggings = playerstats.Leggings.Value
end


game.Players.PlayerAdded:Connect(function(plr)
	
	local inLobby = Instance.new("BoolValue")
	inLobby.Name = "inLobby"
	inLobby.Value = true
	inLobby.Parent = plr
	
	local isCitizen = Instance.new("BoolValue")
	isCitizen.Name = "isCitizen"
	isCitizen.Value = false
	isCitizen.Parent = plr
	
	local inCombat = Instance.new("BoolValue")
	inCombat.Name = "inCombat"
	inCombat.Value = false
	inCombat.Parent = plr
	
	local isRunning = Instance.new("BoolValue")
	isRunning.Name = "isRunning"
	isRunning.Value = false
	isRunning.Parent = plr

	local joinedTime = Instance.new("NumberValue")
	joinedTime.Name = "joinedTime"
	joinedTime.Value = game:GetService("Lighting").ClockTime
	joinedTime.Parent = plr
	
	local time2 = game:GetService("Lighting").ClockTime + 0.5
	local joinedTime2 = Instance.new("NumberValue")
	joinedTime2.Name = "joinedTime2"
	joinedTime2.Value = time2
	joinedTime2.Parent = plr
	
	local quota = Instance.new("NumberValue")
	quota.Name = "Quota"
	quota.Value = 0
	quota.Parent = plr
	
	local wantedLevel = Instance.new("NumberValue")
	wantedLevel.Name = "wantedLevel"
	wantedLevel.Value = 0
	wantedLevel.Parent = plr
	
	local ownedProperties = Instance.new("IntValue")
	ownedProperties.Name = "ownedProperties"
	ownedProperties.Value = 0
	ownedProperties.Parent = plr
	
	local maxOwnedProperties = Instance.new("IntValue")
	maxOwnedProperties.Name = "maxOwnedProperties"
	maxOwnedProperties.Value = 1
	maxOwnedProperties.Parent = plr
	
	
	
	local extrastats = Instance.new("Folder")
	extrastats.Name = "extrastats"
	extrastats.Parent = plr
	
	local daysSurvived = Instance.new("NumberValue")
	daysSurvived.Name = "daysSurvived"
	daysSurvived.Value = 0
	daysSurvived.Parent = extrastats
	
	local maxDaysSurvived = Instance.new("NumberValue")
	maxDaysSurvived.Name = "maxDaysSurvived"
	maxDaysSurvived.Value = 0
	maxDaysSurvived.Parent = extrastats
	
	local walkSpeedMultiplier = Instance.new("NumberValue")
	walkSpeedMultiplier.Name = "walkSpeedMultiplier"
	walkSpeedMultiplier.Value = 1
	walkSpeedMultiplier.Parent = plr
	
	local canSaveData = Instance.new("BoolValue")
	canSaveData.Name = "canSaveData"
	canSaveData.Value = true
	canSaveData.Parent = plr
	
	local robbingBank = Instance.new("BoolValue")
	robbingBank.Name = "robbingBank"
	robbingBank.Value = false
	robbingBank.Parent = plr
	
	local plrAmmo = Instance.new("Folder")
	plrAmmo.Name = "plrAmmo"
	plrAmmo.Parent = plr
	

	
	-- Ammo names start with "a", don't put full stops in the name
	
	local a556 = Instance.new("IntValue")
	a556.Name = "a556x45mm"
	a556.Value = 0
	a556.Parent = plrAmmo
	
	local a9x18 = Instance.new("IntValue")
	a9x18.Name = "a9x18mm"
	a9x18.Value = 0
	a9x18.Parent = plrAmmo
	
	local a338Lapua = Instance.new("IntValue")
	a338Lapua.Name = "a338Lapua"
	a338Lapua.Value = 0
	a338Lapua.Parent = plrAmmo
	
	local a762 = Instance.new("IntValue")
	a762.Name = "a762x39mm"
	a762.Value = 0
	a762.Parent = plrAmmo
	
	local a45Auto = Instance.new("IntValue")
	a45Auto.Name = "a45Auto"
	a45Auto.Value = 0
	a45Auto.Parent = plrAmmo
	
	--Player stats
	
	local playerstats = Instance.new("Folder")
	playerstats.Name = "playerstats"
	playerstats.Parent = plr
	
	local customisationOptions = Instance.new("Folder")
	customisationOptions.Name = "customisationOptions"
	customisationOptions.Parent = plr
	
	local shirt = Instance.new("StringValue")
	shirt.Name = "Shirt"
	shirt.Value = "denimJacket"
	shirt.Parent = customisationOptions
	
	local pants = Instance.new("StringValue")
	pants.Name = "Pants"
	pants.Value = "denimPants"
	pants.Parent = customisationOptions
	
	local hair = Instance.new("StringValue")
	hair.Name = "Hair"
	hair.Value = "dreads"
	hair.Parent = customisationOptions
	
	
	
	local charisma = Instance.new("IntValue")
	charisma.Name = "Charisma"
	charisma.Value = 10
	charisma.Parent = playerstats
	
	local stamina = Instance.new("IntValue")
	stamina.Name = "Stamina"
	stamina.Value = 100
	stamina.Parent = playerstats
	
	local sanity = Instance.new("IntValue")
	sanity.Name = "Sanity"
	sanity.Value = 100
	sanity.Parent = playerstats
	
	local hygiene = Instance.new("IntValue")
	hygiene.Name = "Hygiene"
	hygiene.Value = 100
	hygiene.Parent = playerstats
	
	local saturation = Instance.new("NumberValue")
	saturation.Name = "Saturation"
	saturation.Value = 100
	saturation.Parent = playerstats
	
	local hydration = Instance.new("NumberValue")
	hydration.Name = "Hydration"
	hydration.Value = 100
	hydration.Parent = playerstats
	
	local occupation = Instance.new("StringValue")
	occupation.Name = "Occupation"
	occupation.Value = "Unemployed"
	occupation.Parent = playerstats
	
	local bounty = Instance.new("NumberValue")
	bounty.Name = "Bounty"
	bounty.Value = 0
	bounty.Parent = playerstats
	
	-- Armor name values
	
	local helmet = Instance.new("StringValue")
	helmet.Name = "Helmet"
	helmet.Value = "None"
	helmet.Parent = playerstats
	
	local vest = Instance.new("StringValue")
	vest.Name = "Vest"
	vest.Value = "None"
	vest.Parent = playerstats
	
	local leggings = Instance.new("StringValue")
	leggings.Name = "Leggings"
	leggings.Value = "None"
	leggings.Parent = playerstats
	
	-- Resets stats upon respawn
	
	plr.CharacterAdded:Connect(function() -- Adds the armor folder to the player character when available
		--charisma.Value = 10
		--stamina.Value = 100
		--sanity.Value = 100
		--hygiene.Value = 100
		--saturation.Value = 100
		--hydration.Value = 100
		walkSpeedMultiplier.Value = 1
		
		if plr.Character:FindFirstChild("Armor") == nil then
			local armor = Instance.new("Folder")
			armor.Name = "Armor"
			armor.Parent = plr.Character

			local helmet = Instance.new("StringValue")
			helmet.Name = "Helmet"
			helmet.Value = "None"
			helmet.Parent = armor

			local vest = Instance.new("StringValue")
			vest.Name = "Vest"
			vest.Value = "None"
			vest.Parent = armor

			local leggings = Instance.new("StringValue")
			leggings.Name = "Leggings"
			leggings.Value = "None"
			leggings.Parent = armor

			local torsoAttachment = Instance.new("Attachment")
			torsoAttachment.Name = "TorsoAttachment"
			torsoAttachment.Parent = plr.Character.UpperTorso
		end		
		
	end)
	
	local userID = plr.UserId 
	local customisationData


	-- Loads the player data when they spawn

	local success, errorMessage = pcall(function()
		customisationData = httpService:JSONDecode(customisationStore:GetAsync(userID))
	end)
   
	if success then
		if customisationData ~= nil then
			for i, data in pairs(customisationData) do
				
				customisationOptions:GetChildren()[i].Value = data
				
			end
		end 
	end
	
	-- Ammo store
	
	local ammoData

	local success, errorMessage = pcall(function()
		ammoData = httpService:JSONDecode(ammoStore:GetAsync(userID))
	end)

	if success then
		if ammoData ~= nil then
			for i, data in pairs(ammoData) do

				plrAmmo:FindFirstChild(data[1]).Value = data[2]

			end
		end 
	end
	
	-- In game stats store
	
	local gameData

	local success, errorMessage = pcall(function()
		gameData = httpService:JSONDecode(gameStatStore:GetAsync(userID))
	end)
	if success then
		if gameData ~= nil then
			for i, data in pairs(gameData) do

				playerstats:FindFirstChild(data[1]).Value = data[2]

			end
		end 
	end

	-- Extra stats store
	
	local extraData
	
	local success, errorMessage = pcall(function()
		extraData = httpService:JSONDecode(statStore:GetAsync(userID))
	end)
	if success then
		if extraData ~= nil then
			for i, data in pairs(extraData) do

				extrastats:FindFirstChild(data[1]).Value = data[2]

			end
		end 
	end
	
end)

game.Players.PlayerRemoving:Connect(function(plr)
	
	-- Save their customisation
	
	local userID = plr.UserId
	local customisationTable = {}
	for i, v in pairs(plr.customisationOptions:GetChildren()) do
		table.insert(customisationTable, v.Value)
	end
	
	local customisationData = httpService:JSONEncode(customisationTable)
	customisationStore:SetAsync(userID, customisationData)
	
	-- extra stats

	local extraTable = {}
	for i, v in pairs(plr.extrastats:GetChildren()) do
		table.insert(extraTable, {v.Name, v.Value})
	end
	local extraData = httpService:JSONEncode(extraTable)
	statStore:SetAsync(userID, extraData)
	
	

	local ammoTable = {}
	for i, v in pairs(plr.plrAmmo:GetChildren()) do
		table.insert(ammoTable, {v.Name, v.Value})
	end

	local ammoData = httpService:JSONEncode(ammoTable)
	ammoStore:SetAsync(userID, ammoData)

	-- Game stats

	local gameTable = {}
	for i, v in pairs(plr.playerstats:GetChildren()) do
		table.insert(gameTable, {v.Name, v.Value})
	end
	local gameData = httpService:JSONEncode(gameTable)
	gameStatStore:SetAsync(userID, gameData)
	
	
	-- If the player leaves while in combat, it won't save their game stats
	if plr.inCombat.Value == true then 
		--print("no more game stats")
		
		---- Ammo

		--local ammoTable = {}
		--for i, v in pairs(plr.plrAmmo:GetChildren()) do
		--	table.insert(ammoTable, {v.Name, v.Value})
		--end

		--local ammoData = httpService:JSONEncode(ammoTable)
		--ammoStore:SetAsync(userID, {})

		---- Game stats

		--local gameTable = {}
		--for i, v in pairs(plr.playerstats:GetChildren()) do
		--	table.insert(gameTable, {v.Name, v.Value})
		--end
		--local gameData = httpService:JSONEncode(gameTable)
		--gameStatStore:SetAsync(userID, {})

		
		return 
	else -- When the player didn't combat leave so game stats are saved
		
		-- Ammo

		--local ammoTable = {}
		--for i, v in pairs(plr.plrAmmo:GetChildren()) do
		--	table.insert(ammoTable, {v.Name, v.Value})
		--end

		--local ammoData = httpService:JSONEncode(ammoTable)
		--ammoStore:SetAsync(userID, ammoData)

		---- Game stats

		--local gameTable = {}
		--for i, v in pairs(plr.playerstats:GetChildren()) do
		--	table.insert(gameTable, {v.Name, v.Value})
		--end
		--local gameData = httpService:JSONEncode(gameTable)
		--gameStatStore:SetAsync(userID, gameData)
		
	end
	
end)