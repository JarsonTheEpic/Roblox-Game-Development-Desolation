local players = game:GetService("Players")

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.MaxHealth = 300
		humanoid.Health = 300
	end)
end)