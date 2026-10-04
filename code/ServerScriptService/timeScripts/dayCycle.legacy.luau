local lighting = game:WaitForChild("Lighting")
local fogEvent = game:WaitForChild("ServerStorage").Events.fogEvent

local fogChance = 50
local nothingChance = 50

--local streetLamps = game.Workspace.Village.Roads.streetLamps

local onBrickColor = BrickColor.new("New Yeller")
local offBrickColor = BrickColor.new("Dark stone grey")
local onMaterial = Enum.Material.Neon
local offMaterial = Enum.Material.SmoothPlastic

--local function enableLights(state)
	
--	for i, lamp in pairs(streetLamps:GetChildren()) do
		
--		lamp.Model.Light.sideLampPointLight.Enabled = state
		
--		if state then
			
--			lamp.Model.Light.BrickColor = onBrickColor
--			lamp.Model.Light.Material = onMaterial
			
--		else
			
--			lamp.Model.Light.BrickColor = offBrickColor
--			lamp.Model.Light.Material = offMaterial
			
--		end
		
--	end
	
--end

--enableLights(false)

while true do -- 16 minutes in a day is task.wait(2)
	
	task.wait(2)
	
	lighting.ClockTime = lighting.ClockTime + 0.05
	
	if lighting.ClockTime <= 6.1 and lighting.ClockTime > 5.9 then
		--enableLights(false)
	end
	
	if lighting.ClockTime <= 18.1 and lighting.ClockTime > 17.9 then
		--enableLights(true)
	end
	
	if (lighting.ClockTime >= 6 and lighting.ClockTime < 16) then
		
		lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180) -- Midday
		lighting.Brightness = 3

	end
	
	if (lighting.ClockTime >= 16 and lighting.ClockTime < 22) then

		lighting.OutdoorAmbient = Color3.fromRGB(90, 90, 90) -- Afternoon
		lighting.Brightness = 2.25
		
	end
	
	if (lighting.ClockTime >= 22 and lighting.ClockTime < 24) or (lighting.ClockTime > 0 and lighting.ClockTime < 6) then
		
		lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0) -- Midnight
		lighting.Brightness = 1.5
				
	end
	
	if lighting.ClockTime == 20 then
		
		local randomNum = math.random(1, 100)
		
		if randomNum <= fogChance then
			
			fogEvent:Fire()
			
		else
			
			
			
		end
		
	end
	
end