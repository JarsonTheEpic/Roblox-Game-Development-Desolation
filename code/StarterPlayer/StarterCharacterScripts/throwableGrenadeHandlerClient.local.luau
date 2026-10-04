local throwGrenade = game:WaitForChild("ReplicatedStorage").gameplayEvents.throw
local rs = game:WaitForChild("ReplicatedStorage")

local UIS = game:GetService("UserInputService")

repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
repeat task.wait() until plr.Character

local playSound = rs.gameplayEvents.playSound


task.wait(0.5)

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end

local camera = workspace.CurrentCamera
local mouse = plr:GetMouse()

local grenadeStats = {
	["Smoke grenade"] = {
		name = "Smoke grenade",
		armTime = 0.6,
		cooldown = 0.6
	},
	C4 = {
		name = "C4",
		armTime = 2,
		cooldown = 4
	}
}

local plrGrenade
local armed
local holdingLMB = script.holdingLMB
local debounce = false


local grenadeGui = plr.PlayerGui.mobileControls.grenadeGui
local isMobile = false

local throwButton = grenadeGui.throwButton
local crosshair = grenadeGui.crosshair

local crosshairID = "http://www.roblox.com/asset/?id=9947945465"
local defaultMouse = mouse.Icon

function updateInput()
	local lastInput = UIS:GetLastInputType()
	if lastInput == Enum.UserInputType.Focus then return end -- ignore if the player focuses on the app
	grenadeGui.Enabled = lastInput == Enum.UserInputType.Touch -- makes the frame visible if the user touched the screen
	isMobile = lastInput == Enum.UserInputType.Touch
end


updateInput()
UIS.LastInputTypeChanged:Connect(updateInput)


local function lockMouse(char)

	if plr.PlayerGui.storageGui.Frame.Visible == true then return end -- If the player's storage frame is open, then don't lock mouse

	local hum = char.Humanoid
	local camera = workspace.CurrentCamera	
	hum.CameraOffset = Vector3.new(1.65, 0, 0.1)
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

end

local function unlockMouse(char)

	local hum = char.Humanoid
	hum.CameraOffset = Vector3.new(0, 0, 0)
	UIS.MouseBehavior = Enum.MouseBehavior.Default

end


-- Unlock mouse when storage screen opens

local openStorageScreen = game:WaitForChild("ReplicatedStorage").gameplayEvents.openStorageScreen
openStorageScreen.OnClientEvent:Connect(function()

	unlockMouse(plr.Character)

end)

plr.PlayerGui.storageGui.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
	if plr.PlayerGui.storageGui.Frame.Visible then 
		unlockMouse(plr.Character)
	else
		if plrGrenade ~= nil then -- If the player has a gun equipped
			lockMouse(plr.Character)
		end
	end
end)


plr.Character.ChildAdded:Connect(function(grenade)

	for i, child in grenadeStats do
		if grenade.Name == child.name then
			
			lockMouse(plr.Character)
			
			throwButton.Visible = true
			crosshair.Visible = true

			plrGrenade = grenade
			armed = plrGrenade.armed
			
			mouse.Icon = crosshairID

			return
		end
	end

end)

plr.Character.ChildRemoved:Connect(function(grenade)
	
	for i, child in grenadeStats do
		if grenade.Name == child.name then
			
			unlockMouse(plr.Character)
			
			throwButton.Visible = false
			crosshair.Visible = false

			plrGrenade = nil
			armed.Value = false
			armed = nil

			mouse.Icon = defaultMouse

			return
		end
	end 
	
end)


local function throw()	
	local cameraCF = camera.CFrame

	local params = RaycastParams.new()
	
	local viewportSize = camera.ViewportSize
	local ray = camera:ViewportPointToRay(
		viewportSize.X / 2,
		viewportSize.Y / 2
	)

	local hitPoint = ray.Origin + ray.Direction * 1000

	armed.Value = false
	throwGrenade:FireServer(hitPoint, plrGrenade)

	debounce = true
	wait(grenadeStats[plrGrenade.Name].cooldown)
	debounce = false

end


UIS.InputBegan:Connect(function(I, E)
	
	if plrGrenade == nil then return end
	
	if E then return end
	
	if I.UserInputType == Enum.UserInputType.MouseButton1 then
		
		local success, err = pcall(function()
			
			playSound:FireServer(plrGrenade.Handle.Arm, plrGrenade)

			holdingLMB.Value = true
			task.wait(grenadeStats[plrGrenade.Name].armTime)
			armed.Value = true
			
		end)

	end
	
	
end)

UIS.InputEnded:Connect(function(I, E)

	if E then return end
	
	if I.UserInputType == Enum.UserInputType.MouseButton1 then
		
		holdingLMB.Value = false

	end

end)


throwButton.MouseButton1Down:Connect(function()
	
	if plrGrenade == nil then return end

	local success, err = pcall(function()

		playSound:FireServer(plrGrenade.Handle.Arm, plrGrenade)

		holdingLMB.Value = true
		task.wait(grenadeStats[plrGrenade.Name].armTime)
		armed.Value = true

	end)
	
end)

throwButton.MouseButton1Up:Connect(function()
	
	holdingLMB.Value = false
	
end)


game:GetService("RunService").Stepped:Connect(function()

	if plrGrenade == nil then return end
	if holdingLMB.Value == false and armed.Value == true and debounce == false then

		throw()

	end
	
	if plrGrenade and isMobile == false then
		mouse.Icon = crosshairID
	end

end)