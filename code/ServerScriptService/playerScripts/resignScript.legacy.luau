local resignEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.resignEvent

resignEvent.OnServerEvent:Connect(function(plr)
	
	plr.Quota.Value = 0
	plr.playerstats.Occupation.Value = "Unemployed"
	
end)

