local openStorageScreen = game:WaitForChild("ReplicatedStorage").gameplayEvents.openStorageScreen
local takeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.takeEvent
local listItems = game:WaitForChild("ReplicatedStorage").gameplayEvents.listStorage
local storeEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.storeEvent

repeat task.wait() until game.Players.LocalPlayer
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local storageGui = plr.PlayerGui:WaitForChild("storageGui")
local storageFrame = storageGui.Frame.storageFrame
local exampleItem = plr.PlayerGui.storageGui.Frame.storageFrame.item:Clone()
local takeLabel = storageGui.Frame.take
local storeLabel = storageGui.Frame.store
local selectedItem = storageGui.Frame.selectedItem

local function handleStorage(storagePoint)
	
	takeLabel.Text = ""
	
	local storage = listItems:InvokeServer(storagePoint)


	for i, item in pairs(storage) do

		local itemButton = exampleItem:Clone()
		itemButton.Name = item
		itemButton.Text = item
		itemButton.Parent = storageFrame
		itemButton.Visible = true

		itemButton.Position = UDim2.new(0, 0, (i - 1) * 0.1, 0)

	end

	for i, button in pairs(storageFrame:GetChildren()) do

		if button:IsA("TextButton") == false and button:IsA("ImageButton") == false then return end

		button.Activated:Connect(function()

			selectedItem.Value = button.Name
			takeLabel.Text = selectedItem.Value

		end)

	end
	
end

openStorageScreen.OnClientEvent:Connect(function(storagePoint)
	
	storageGui.Frame.Visible = true

	storageFrame:ClearAllChildren()
	
	local ownStoragePoint = storageGui.Frame.storagePoint
	ownStoragePoint.Value = storagePoint
	
	local storage = listItems:InvokeServer(storagePoint)

	
	handleStorage(storagePoint)
	
end)

storeEvent.OnClientEvent:Connect(function(storagePoint)
	
	handleStorage(storagePoint)
	
end)

takeEvent.OnClientEvent:Connect(function(storagePoint)

	handleStorage(storagePoint)

end)

