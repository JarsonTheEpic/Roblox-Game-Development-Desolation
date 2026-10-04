local module = {}

local armorFolder = game:WaitForChild("ServerStorage").Accessories.Armor
local plrTips = game:WaitForChild("ReplicatedStorage").plrTipsEvent

local sound = script.equipSound

local function addArmor(tool, plr, armorType, putOn)
	local char = plr.Character
	
	if putOn == true then
		
		char.Armor:FindFirstChild(armorType).Value = tool.Name
		
		tool.Handle.Transparency = 1
		
		local cloneArmor = armorFolder:FindFirstChild(tool.Name, true):Clone()
		cloneArmor.Parent = char
		
		local cloneSound = sound:Clone()
		cloneSound.Parent = char.HumanoidRootPart
		cloneSound:Remove()
		
	else
		
		char.Armor:FindFirstChild(armorType).Value = "None"
		
		tool.Handle.Transparency = 0
		
		for i, child in pairs (char:GetChildren()) do
			if child:IsA("Accessory") and child.Name == tool.Name then
				child:Destroy()
			end
		end
		
		local cloneSound = sound:Clone()
		cloneSound.Parent = char.HumanoidRootPart
		cloneSound:Remove()
		
		--char:FindFirstChild(tool.Name):Destroy()
		
	end
	
end

function module.equip(tool, plr, armorType)
	
	local isEquipped = tool.isEquipped
	
	if isEquipped.Value == false and plr.Character.Armor:FindFirstChild(armorType).Value == "None" then
		
		isEquipped.Value = true
		addArmor(tool, plr, armorType, true)
		
		plrTips:FireClient(plr, "Equipped ".. tool.Name, 3)
		
	elseif isEquipped.Value == false and plr.Character.Armor:FindFirstChild(armorType).Value ~= "None" then
		
		plrTips:FireClient(plr, "You are already wearing another piece of armor", 3)

		
		--Does nothing ts code pmo
		
		--isEquipped.Value = false
		--addArmor(tool, plr, armorType, true)
		
	else
		
		isEquipped.Value = false
		addArmor(tool, plr, armorType, false)
		
		plrTips:FireClient(plr, "Unequipped ".. tool.Name, 3)
		
	end
end

return module
