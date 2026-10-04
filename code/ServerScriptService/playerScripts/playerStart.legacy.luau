local rs = game:WaitForChild("ReplicatedStorage")

local startGame = rs.startGame
local spawnPoints = game:WaitForChild("Workspace").spawnLobby.spawnPoints
local debris = game:GetService("Debris")


local function giveForcefield(plr, duration)
	
	for i, v in plr.Character:GetChildren() do
		if v.Name == "ForceField" then
			v:Destroy()
		end
	end
	
	local spawnProtection = Instance.new("ForceField")
	spawnProtection.Parent = plr.Character
	debris:AddItem(spawnProtection, duration)
	
end

startGame.OnServerEvent:Connect(function(plr)
	
	startGame:FireAllClients()

	
	local spawnPart = spawnPoints:GetChildren()[math.random(1, #spawnPoints:GetChildren())]
	
	plr.PlayerGui.playerInfo.openPlayerInfo.Visible = true -- Makes the player info button visible upon join
	plr.Character:MoveTo(spawnPart.Position)
	
	giveForcefield(plr, 5)
	
	-- Edit stats
	local playerstats = plr.playerstats
	plr.inLobby.Value = false
	--playerstats.Saturation.Value = 100
	--playerstats.Hydration.Value = 100
	
	
	-- On death
	plr.Character.Humanoid.Died:Connect(function()
		plr.inLobby.Value = true
		task.wait(game.Players.RespawnTime)

		giveForcefield(plr, 9999)
	end)
	
end)