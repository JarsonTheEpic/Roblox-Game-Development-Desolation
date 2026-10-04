local serverStorage = game:WaitForChild("ServerStorage")
local plrHitbox = game:WaitForChild("ServerStorage").plrHitboxes.plrBodyHitbox
local plrHeadHitbox = game:WaitForChild("ServerStorage").plrHitboxes.plrHeadHitbox
local plrDrownHitbox = game:WaitForChild("ServerStorage").plrHitboxes.plrDrownHitbox

game.Players.PlayerAdded:Connect(function(plr)
		
	plr.CharacterAdded:Connect(function(char)
				
		for i, child in pairs(char:GetDescendants()) do

			if child:IsA("BasePart") and child.Name ~= "plrBodyHitbox" and child.Name ~= "plrHeadHitbox" and child.Name ~= "plrDrownHitbox" and child.Name ~= "limbHitbox1" and child.Name ~= "limbHitbox2" and child.Name ~= "limbHitbox3" and child.Name ~= "limbHitbox4" then
				
				child.CanQuery = false
				child.CanTouch = true -- Leave this false so other parts can't be touched

			elseif child.Name == "plrBodyHitbox" or child.Name == "plrHeadHitbox" then
				
				child:Destroy()
				
			end
			
			if child:IsA("Accessory") then
				
				local handle = child:FindFirstChild("Handle", 1)
				handle.CanCollide = false
				handle.CanQuery = false
				handle.CanTouch = false
				
			end

		end
		
		local newHitbox = plrHitbox:Clone()
		local newHeadHitbox = plrHeadHitbox:Clone()
		local newDrownHitbox = plrDrownHitbox:Clone()
		local mainHitbox = serverStorage.plrHitboxes.plrMainHitbox:Clone()
		
		--mainHitbox.Parent = char
		--local newMainHitboxWeld = Instance.new("Weld")
		--mainHitbox.CanQuery = false

		--local humRootCFrame = char.HumanoidRootPart.CFrame

		--newMainHitboxWeld.Parent = mainHitbox
		--newMainHitboxWeld.Part0 = mainHitbox
		--newMainHitboxWeld.Part1 = char.HumanoidRootPart

		--local humRootCFrame = char.HumanoidRootPart.CFrame
		
		
		newHitbox.Parent = char
		local newHitboxWeld = Instance.new("Weld")
		
		local humRootCFrame = char.HumanoidRootPart.CFrame
		
		newHitboxWeld.Parent = newHitbox
		newHitboxWeld.Part0 = newHitbox
		newHitboxWeld.Part1 = char.HumanoidRootPart
		
		local humRootCFrame = char.HumanoidRootPart.CFrame
		--newHitboxWeld.C0 = CFrame.new(0, 1, 0)
		
		
		newHeadHitbox.Parent = char
		local newHeadHitboxWeld = Instance.new("WeldConstraint")

		newHeadHitboxWeld.Parent = newHeadHitbox
		newHeadHitboxWeld.Part0 = newHeadHitbox
		newHeadHitboxWeld.Part1 = char.Head

		newHeadHitbox.Position = char.Head.Position
		
		newHitbox.CFrame = humRootCFrame
		
		
		newDrownHitbox.Parent = char
		local newDrownHitboxWeld = Instance.new("WeldConstraint")

		newDrownHitboxWeld.Parent = newDrownHitbox
		newDrownHitboxWeld.Part0 = newDrownHitbox
		newDrownHitboxWeld.Part1 = char.Head

		newDrownHitbox.Position = char.Head.Position
		
		-- Add limb Hitboxes
		
		local limbHitbox1 = serverStorage.plrHitboxes.plrArmHitbox:Clone()

		limbHitbox1.Parent = char
		local limbWeld1 = Instance.new("WeldConstraint")

		limbWeld1.Parent = limbHitbox1
		limbWeld1.Part0 = limbHitbox1
		limbWeld1.Part1 = char.LeftUpperArm

		limbHitbox1.Position = char.LeftUpperArm.Position
		
		
		local limbHitbox2 = serverStorage.plrHitboxes.plrArmHitbox:Clone()

		limbHitbox2.Parent = char
		local limbWeld2 = Instance.new("WeldConstraint")

		limbWeld2.Parent = limbHitbox2
		limbWeld2.Part0 = limbHitbox2
		limbWeld2.Part1 = char.RightUpperArm

		limbHitbox2.Position = char.RightUpperArm.Position
		
		
		local limbHitbox3 = serverStorage.plrHitboxes.plrArmHitbox:Clone()
		
		limbHitbox3.Parent = char
		local limbWeld3 = Instance.new("WeldConstraint")

		limbWeld3.Parent = limbHitbox3
		limbWeld3.Part0 = limbHitbox3
		limbWeld3.Part1 = char.LeftUpperLeg

		limbHitbox3.Position = char.LeftUpperLeg.Position
		
		
		local LimbHitbox4 = serverStorage.plrHitboxes.plrArmHitbox:Clone()

		LimbHitbox4.Parent = char
		local limbWeld4 = Instance.new("WeldConstraint")

		limbWeld4.Parent = LimbHitbox4
		limbWeld4.Part0 = LimbHitbox4
		limbWeld4.Part1 = char.RightUpperLeg

		LimbHitbox4.Position = char.RightUpperLeg.Position

	end)
	
end)