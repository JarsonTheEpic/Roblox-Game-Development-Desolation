game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		local count = 0
		
		local daysSurvived = plr.extrastats.daysSurvived
		local maxDaysSurvived = plr.extrastats.maxDaysSurvived
		
		while plr.Character do
			task.wait(1)
			if plr.inLobby.Value == false then
				count += 1
			end
			
			if count >= 960 then -- 960 is 16 minutes, length of a whole day
				count = 0
				daysSurvived.Value += 1
				if daysSurvived.Value > maxDaysSurvived.Value then
					maxDaysSurvived.Value = daysSurvived.Value
				end
			end
		end
		
	end)
end)
