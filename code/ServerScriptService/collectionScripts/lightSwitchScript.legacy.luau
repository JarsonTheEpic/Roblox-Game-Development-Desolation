local collectionService = game:GetService("CollectionService")

for i, switch in pairs (collectionService:GetTagged("lightSwitch")) do
	
	local clickDetector = switch:FindFirstChild("ClickDetector", 1)
	
	clickDetector.MouseClick:Connect(function(plr)
		
		if switch:FindFirstChild("connectedLight") then -- If the light itself is not in the switch model
			
			if switch.isOn.Value == true then
				switch.isOn.Value = false
				switch.Off.Transparency = 0
				switch.On.Transparency = 1
				
				if switch.connectedLight.Value.Light:FindFirstChild("PointLight") then
					switch.connectedLight.Value.Light.PointLight.Enabled = false
				end

				if switch.connectedLight.Value.Light:FindFirstChild("SurfaceLight") then
					switch.connectedLight.Value.Light.SurfaceLight.Enabled = false
				end

				if switch.connectedLight.Value.Light:FindFirstChild("SpotLight") then
					switch.connectedLight.Value.Light.SpotLight.Enabled = false
				end
				
				switch.connectedLight.Value.Light.Material = Enum.Material.SmoothPlastic
				switch.connectedLight.Value.Light.BrickColor = BrickColor.new("Dark stone grey")
			else
				switch.isOn.Value = true
				switch.Off.Transparency = 1
				switch.On.Transparency = 0
				
				if switch.connectedLight.Value.Light:FindFirstChild("PointLight") then
					switch.connectedLight.Value.Light.PointLight.Enabled = true
				end

				if switch.connectedLight.Value.Light:FindFirstChild("SurfaceLight") then
					switch.connectedLight.Value.Light.SurfaceLight.Enabled = true
				end

				if switch.connectedLight.Value.Light:FindFirstChild("SpotLight") then
					switch.connectedLight.Value.Light.SpotLight.Enabled = true
				end
				
				switch.connectedLight.Value.Light.Material = Enum.Material.Neon
				switch.connectedLight.Value.Light.BrickColor = BrickColor.new("New Yeller")
			end
			
			-- Creates the clicking sound
			local sound = script.click:Clone()
			sound.Parent = switch.clickPart
			sound:Remove()
			
		else	-- The new system (light itself is in the switch model)
			
			if switch.isOn.Value == true then
				switch.isOn.Value = false
				switch.switch.Off.Transparency = 0
				switch.switch.On.Transparency = 1
				
				if switch.light.light:FindFirstChild("PointLight") then
					switch.light.light.PointLight.Enabled = false
				end
				
				if switch.light.light:FindFirstChild("SurfaceLight") then
					switch.light.light.SurfaceLight.Enabled = false
				end
				
				if switch.light.light:FindFirstChild("SpotLight") then
					switch.light.light.SpotLight.Enabled = false
				end
				
				switch.light.light.Material = Enum.Material.SmoothPlastic
				switch.light.light.BrickColor = BrickColor.new("Dark stone grey")
			else
				switch.isOn.Value = true
				switch.switch.Off.Transparency = 1
				switch.switch.On.Transparency = 0
				
				if switch.light.light:FindFirstChild("PointLight") then
					switch.light.light.PointLight.Enabled = true
				end

				if switch.light.light:FindFirstChild("SurfaceLight") then
					switch.light.light.SurfaceLight.Enabled = true
				end

				if switch.light.light:FindFirstChild("SpotLight") then
					switch.light.light.SpotLight.Enabled = true
				end
				
				switch.light.light.Material = Enum.Material.Neon
				switch.light.light.BrickColor = BrickColor.new("New Yeller")
			end
			
			-- Creates a clicking sound
			local sound = script.click:Clone()
			sound.Parent = switch.switch.clickPart
			sound:Remove()
			
		end
		
	end)
end
