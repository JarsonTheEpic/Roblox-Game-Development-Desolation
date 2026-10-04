local fogEvent = game:WaitForChild("ServerStorage").Events.fogEvent

local Lighting = game:WaitForChild("Lighting")
Lighting.Atmosphere.Density = 0.25

fogEvent.Event:Connect(function()
	
	for i = 0, 100, 1 do
		Lighting.Atmosphere.Density += 0.01
		task.wait(0.2)
	end
	
	task.wait(720)
	
	for i = 0, 100, 1 do
		Lighting.Atmosphere.Density += 0.01
		task.wait(0.2)
	end
	
end)