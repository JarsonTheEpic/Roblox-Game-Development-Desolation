local marketPlaceService = game:GetService("MarketplaceService")
local serverStorage = game:WaitForChild("ServerStorage")
local shirts = serverStorage.Accessories.Shirts
local pants = serverStorage.Accessories.Pants
local hair = serverStorage.Accessories.Hair



local defaultShirtID = 144076436
local defaultPantsID = 144076760

local replicatedStorage = game:WaitForChild("ReplicatedStorage")
local startGame = replicatedStorage.startGame
local customiseEvent = replicatedStorage.customise

local function updateChar(plr, clothesType, clothesName) -- Ensures the player's new avatar is up to date
	local char = plr.Character or plr.CharacterAdded:Wait()

	local customiseOptions = plr:FindFirstChild("customisationOptions")

	if clothesType == 1 then
		customiseOptions.Shirt.Value = clothesName
	elseif clothesType == 2 then
		customiseOptions.Pants.Value = clothesName
	elseif clothesType == 3 then
		customiseOptions.Hair.Value = clothesName
	end
	customiseEvent:FireClient(plr)
	
	
	for i, child in pairs(char:GetChildren()) do -- Delete player's own accessories

		if child.ClassName == "Accessory" or child.Name == "Shirt Graphic" or child.ClassName == "Shirt" or child.ClassName == "Pants" then
			child:Destroy()
		end

	end
	local customisationOptions = plr.customisationOptions


	local newShirt = shirts:FindFirstChild(customisationOptions.Shirt.Value):Clone()
	newShirt.Parent = char

	local newPants = pants:FindFirstChild(customisationOptions.Pants.Value):Clone()
	newPants.Parent = char


	local newHair = hair:FindFirstChild(customisationOptions.Hair.Value):Clone()
	newHair.Parent = char
end


game.Players.PlayerAdded:Connect(function(plr)
	updateChar(plr)
	plr.CharacterAdded:Connect(function()
		updateChar(plr)
	end)
end)



startGame.OnServerEvent:Connect(updateChar)

customiseEvent.OnServerEvent:Connect(updateChar)

