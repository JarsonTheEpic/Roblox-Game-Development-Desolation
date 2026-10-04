local replicatedStorage = game:WaitForChild("ReplicatedStorage")
local playSound = replicatedStorage.gameplayEvents.playSound
local playSoundServer = replicatedStorage.gameplayEvents.playSoundServer

playSound.OnServerEvent:Connect(function(plr, sound, tool, min, max)
	
	if not sound then return end
	
	local cloneSound = sound:Clone()
	cloneSound.PlayOnRemove = true
	cloneSound.Parent = tool.Handle
	
	if min then
		cloneSound.RollOffMinDistance = min
	end

	if max then
		cloneSound.RollOffMinDistance = max
	end
	
	cloneSound:Destroy()
	
end)

playSoundServer.Event:Connect(function(sound, tool, min, max) -- Same function but for server to server communication
	
	if not sound then return end
	
	local cloneSound = sound:Clone()
	cloneSound.PlayOnRemove = true
	cloneSound.Parent = tool.Handle
	
	if min then
		cloneSound.RollOffMinDistance = min
	end

	if max then
		cloneSound.RollOffMinDistance = max
	end
	
	cloneSound:Destroy()
	
end)