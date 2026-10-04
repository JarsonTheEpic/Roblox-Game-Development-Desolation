-- Saves leaderstats

local dataStore = game:GetService("DataStoreService")

local cronsStore = dataStore:GetDataStore("cronsStore") 

game.Players.PlayerAdded:Connect(function(plr)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local cron = Instance.new("NumberValue")
	cron.Name = "Crons"
	cron.Value = 100
	cron.Parent = leaderstats
	
	local userID = plr.UserId
	local data
	
	local success, errorMessage = pcall(function()
		data = cronsStore:GetAsync(userID)
	end)
	
	
	if success then
		cron.Value = data -- Gets user data
	end
	
end)

game.Players.PlayerRemoving:Connect(function(plr)
	local userID = plr.UserId
	local cronsData = plr.leaderstats.Crons.Value
	
	cronsStore:SetAsync(userID, cronsData)
end)