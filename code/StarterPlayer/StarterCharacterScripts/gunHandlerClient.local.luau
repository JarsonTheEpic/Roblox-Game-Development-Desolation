repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
repeat task.wait() until plr.Character


local isRunningEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.runEvent


task.wait(1.5)

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end


local mouse = plr:GetMouse()
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local serverRemote = game:WaitForChild("ReplicatedStorage").gameplayEvents.gunRemotes.serverGunRemote
local updateSpeed = game:WaitForChild("ReplicatedStorage").gameplayEvents.updateSpeedEvent -- Updates player speed when equip gun
local humanoid = plr.Character:FindFirstChild("Humanoid")

local crosshairID = "http://www.roblox.com/asset/?id=9947945465"
local defaultMouse = mouse.Icon

local debounce = false

local gunStats = { -- Name, Damage, Body Multipler, Headshot Multipler, Pellet count, Firerate, Aimspeed, Reload time, Cartridge
	M4A1 = {
		"M4A1", -- Name
		1 / 13.3, -- Firerate
		40, -- Zoomed in FOV
		2.8, -- Reload time
		2, -- Firemode
		0.34, -- Reload adjustment multiplier
		"a556x45mm", -- cartridge
		false, -- Has a scope by default?
		0.2, -- Aim time
		0.25, -- Aim sensitivity
		0.18, -- Vertical recoil (Repeated 3 times)
		0.1, -- Horizontal recoil 
		sidewaysRecoil = 0.01
	},
	
	AK47 = {
		"AK47", -- Name
		1 / 10, -- Firerate
		40, -- Zoomed in FOV
		3.8, -- Reload time
		2, -- Firemode
		0.25, -- Reload adjustment multiplier
		"a762x39mm", -- cartridge
		false, -- Has a scope by default?
		0.2, -- Aim time
		0.25, -- Aim sensitivity
		0.28, -- Vertical recoil (Repeated 3 times)
		0.18, -- Horizontal recoil 
		sidewaysRecoil = 0.0165
	},
	
	["Scar-L"] = {
		"Scar-L", -- Name
		1 / 10.8, -- Firerate
		40, -- Zoomed in FOV
		2.8, -- Reload time
		2, -- Firemode
		0.34, -- Reload adjustment multiplier
		"a556x45mm", -- cartridge
		false, -- Has a scope by default?
		0.3, -- Aim time
		0.25,
		0.2,
		0.12,
		sidewaysRecoil = 0.02
	},
	
	Makarov = {
		"Makarov",
		1 / 7,
		55, 
		1.5, 
		1,
		1,
		"a9x18mm",
		false,
		0.1,
		0.25,
		0.1,
		0.1,
		sidewaysRecoil = 0.006
	},
	
	GCP45 = {
		"GCP45",
		1 / 5,
		55, 
		1.5, 
		1,
		1,
		"a45Auto",
		false,
		0.1,
		0.25,
		0.18,
		0.12,
		sidewaysRecoil = 0.008
	},
	
	CAP10 = {
		"CAP10",
		1 / 18,
		55, 
		1.5, 
		2,
		0.8,
		"a45Auto",
		false,
		0.15,
		0.25,
		0.25,
		0.3,
		sidewaysRecoil = 0.015
	},
	
	GMP45 = {
		"GMP45",
		1 / 11,
		55, 
		2, 
		2,
		0.4,
		"a45Auto",
		false,
		0.15,
		0.25,
		0.24,
		0.1,
		sidewaysRecoil = 0.01
	},
	
	AWM = {
		"AWM",
		3 / 2,
		70 / 10, -- 10x zoom
		2.8, 
		1,
		0.34,
		"a338Lapua",
		true,
		0.5,
		0.25,
		2,
		1.1,
		0.7,
		sidewaysRecoil = 0.04
	}
}


local ADSEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.gunRemotes.ADSEvent
local reloadEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.gunRemotes.reloadEvent
local ammoFolder = plr.plrAmmo

local idleTrack = nil
local ADSTrack = nil
local Hipfire = nil
local fire = nil
local reload = nil

local holdingMouse = false
local holdingRMB = script.holdingRMB
local lastFire = 0

local gunName = nil
local gunNumber = 0

local equipped = false
local plrGun


-- Mobile controls

local gunGui = plr.PlayerGui.mobileControls.gunGui
local isMobile = false

local shootButton = gunGui.shootButton
local aimButton = gunGui.aimButton
local reloadButton = gunGui.reloadButton
local crosshair = gunGui.crosshair

function updateInput()
	local lastInput = UIS:GetLastInputType()
	if lastInput == Enum.UserInputType.Focus then return end -- ignore if the player focuses on the app
	gunGui.Enabled = lastInput == Enum.UserInputType.Touch -- makes the frame visible if the user touched the screen
	isMobile = lastInput == Enum.UserInputType.Touch
end


updateInput()
UIS.LastInputTypeChanged:Connect(updateInput)


local function lockMouse(char)
	
	if plr.PlayerGui.storageGui.Frame.Visible == true then return end -- If the player's storage frame is open, then don't lock mouse
	
	local hum = char.Humanoid
	local camera = workspace.CurrentCamera
	
	-- Different viewmodel based on device
	if isMobile then
		hum.CameraOffset = Vector3.new(1.65, 0, 0.1)
	else
		hum.CameraOffset = Vector3.new(1.65, 0, 0.1)
	end
	
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

end


local function unlockMouse(char)
	
	local hum = char.Humanoid
	hum.CameraOffset = Vector3.new(0, 0, 0)
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	
end


plr.Character.Head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
	
	local transparency = plr.Character.Head.LocalTransparencyModifier
	
	if plrGun == nil then return end
	
	if transparency > 0.5 then
		-- First person
		if not isMobile then
			unlockMouse(plr.Character)
		end
	else
		-- Third person
		lockMouse(plr.Character)
	end
		
end)


-- Unlock mouse when storage screen opens

local openStorageScreen = game:WaitForChild("ReplicatedStorage").gameplayEvents.openStorageScreen
openStorageScreen.OnClientEvent:Connect(function()
	
	unlockMouse(plr.Character)
	
end)

plr.PlayerGui.storageGui.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
	if plr.PlayerGui.storageGui.Frame.Visible then 
		unlockMouse(plr.Character)
	else
		if plrGun ~= nil then -- If the player has a gun equipped
			lockMouse(plr.Character)
		end
	end
end)


RunService.RenderStepped:Connect(function()
	if equipped and isMobile == false then
		mouse.Icon = crosshairID
	end
end)


local camera = workspace.CurrentCamera


local function recoilFunction(verticalIntensity, horizontalIntensity, increment, time1, sidewaysIntensity)
	
	--task.wait() -- Delay for a bit or the gun will recoil before the shot is fired

	-- Times calculation by 1000 or it won't give a random
	local horizonalOffset = math.random(-horizontalIntensity * 1000, horizontalIntensity * 1000) / 1000
	
	local sidewaysDirection = math.random(0, 1)
	if sidewaysDirection == 0 then
		sidewaysIntensity = -sidewaysIntensity
	end
	
	for i = 0, time1, increment do
		local goal = camera.CFrame * CFrame.Angles(math.rad(verticalIntensity), math.rad(horizonalOffset), sidewaysIntensity)
		local newCF = camera.CFrame:Lerp(goal, i)
		camera.CFrame = newCF
		RunService.RenderStepped:Wait()
	end
	
	return true
end


plr.Character.ChildAdded:Connect(function(gun)

	for i, v in gunStats do -- Loops through the list of guns, to see if the newly added tool is actually a gun
		if gun.Name == v[1] then
			
			reloadButton.Visible = true -- Shows mobile gun controls
			shootButton.Visible = true
			aimButton.Visible = true
			crosshair.Visible = true
			
			
			lockMouse(plr.Character)
			
			gunName = v[1]
			gunNumber = i
			equipped = true
			plrGun = gun

			idleTrack = humanoid.Animator:LoadAnimation(gun.Idle)
			ADSTrack = humanoid.Animator:LoadAnimation(gun.ADS)
			Hipfire = humanoid.Animator:LoadAnimation(gun.Hipfire)
			fire = humanoid.Animator:LoadAnimation(gun.fire)
			reload = humanoid.Animator:LoadAnimation(gun.reload)	
			
			idleTrack:Play()
			mouse.Icon = crosshairID
			
			--updateSpeed:FireServer(gun, true)
			
			return
		end
	end

end)

plr.Character.ChildRemoved:Connect(function(gun)
	--print(gun)

	if gun.Name == gunName then
		
		reloadButton.Visible = false -- Hides mobile gun control
		shootButton.Visible = false
		aimButton.Visible = false
		crosshair.Visible = false
		
		
		unlockMouse(plr.Character)
				
		holdingRMB.Value = false

		local properties = {FieldOfView = 70}
		local info = TweenInfo.new(gunStats[gunNumber][9] / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,.1)
		local tween = game:GetService("TweenService"):Create(game.Workspace.CurrentCamera, info, properties)
		tween:Play()
		ADSTrack:Stop()

		UIS.MouseDeltaSensitivity = 1

		if gunStats[gunNumber][8] == true then

			UIS.MouseIconEnabled = true
			plr.CameraMode = Enum.CameraMode.Classic
			game.Workspace.Camera.CameraType = Enum.CameraType.Custom

		end

		--task.wait(gunStats[gunNumber][9] / 2)
		ADSEvent:FireServer(false, plrGun)
		if gunStats[gunNumber][8] == true and plrGun.aimed.Value == false then

		end

		
		gunName = nil
		gunNumber = 0
		equipped = false
		plrGun = nil
		
		mouse.Icon = defaultMouse
		idleTrack:Stop()
		ADSTrack:Stop()
		ADSEvent:FireServer(false, gun)
		reload:Stop()
		reloadEvent:FireServer(false, gun)
		
		idleTrack = nil
		ADSTrack = nil
		Hipfire = nil
		fire = nil
		reload = nil
		
		--updateSpeed:FireServer(gun, false)
	end

end)



local function shoot()
	
	if debounce == true then return end
	if plrGun.reloading.Value == true then return end
	if plrGun.toolStats.ammoLeft.Value <= 0 then return end
	if plrGun.toolStats.durability.Value <= 0 then return end

	local now = tick()
	if now - lastFire >= gunStats[gunNumber][2] then

		isRunningEvent:FireServer(false)

		debounce = true
		lastFire = now
		local mousePos = UIS:GetMouseLocation()
		holdingMouse = true
		
		
		-- Fires ray from camera to centre of screen to find player's aim point at centre of screen
		local cameraCF = camera.CFrame

		local params = RaycastParams.new()

		local raycastResult = workspace:Raycast(cameraCF.Position, cameraCF.LookVector * 1000, params)
		local hitPoint
		
		if isMobile then
			-- If player is on mobile, different calculations for hit position
			if raycastResult then

				hitPoint = raycastResult.Position -- vector3 that player is looking at

			else

				hitPoint = mouse.Hit.Position

			end
		else
			hitPoint = mouse.Hit.Position
		end
		

		local unitRay = workspace.Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
		local origin = workspace.CurrentCamera.CFrame.Position
		--local direction = unitRay.Direction * 1000

		local verticalRecoil = gunStats[gunNumber][11]
		local horizontalRecoil = gunStats[gunNumber][12]

		serverRemote:FireServer(mousePos, hitPoint, plrGun, plrGun.aimed.Value, mouse.UnitRay, origin)
		
		recoilFunction(verticalRecoil, horizontalRecoil, 1, 3, gunStats[gunNumber].sidewaysRecoil)

		if plrGun.aimed.Value == true then
			fire:Play()
		else
			Hipfire:Play()
		end
		task.wait(0.01)
		debounce = false
	end
	
end


local function aim(aiming)
	
	if aiming then
		
		if plrGun.reloading.Value == true then return end

		holdingRMB.Value = true

		local properties = {FieldOfView = gunStats[gunNumber][3]}
		local info = TweenInfo.new(gunStats[gunNumber][9], Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,.1)
		local tween = game:GetService("TweenService"):Create(game.Workspace.CurrentCamera, info, properties)
		tween:Play()
		ADSTrack:Play()

		task.wait(gunStats[gunNumber][9] / 1)
		if holdingRMB.Value == false then
			ADSEvent:FireServer(false, plrGun)
		else
			ADSEvent:FireServer(true, plrGun)

			UIS.MouseDeltaSensitivity = gunStats[gunNumber][10]

			if gunStats[gunNumber][8] == true then

				UIS.MouseIconEnabled = false
				plr.CameraMode = Enum.CameraMode.LockFirstPerson
				game.Workspace.Camera.CameraType = Enum.CameraType.Custom

			end
		end
		
	else
		
		holdingRMB.Value = false

		local properties = {FieldOfView = 70}
		local info = TweenInfo.new(gunStats[gunNumber][9] / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut,.1)
		local tween = game:GetService("TweenService"):Create(game.Workspace.CurrentCamera, info, properties)
		tween:Play()
		ADSTrack:Stop()

		UIS.MouseDeltaSensitivity = 1

		if gunStats[gunNumber][8] == true then

			UIS.MouseIconEnabled = true
			plr.CameraMode = Enum.CameraMode.Classic
			game.Workspace.Camera.CameraType = Enum.CameraType.Custom

		end

		--task.wait(gunStats[gunNumber][9] / 2)
		ADSEvent:FireServer(false, plrGun)
		if gunStats[gunNumber][8] == true and plrGun.aimed.Value == false then

		end
		
	end
	
end


local function reload()
	
	if plrGun.toolStats.ammoLeft.Value == plrGun.maxAmmo.Value then return end
	if plr.plrAmmo[gunStats[plrGun.Name][7]].Value <= 0 then return end
	if plrGun.reloading.Value == true then return end

	reloadEvent:FireServer(true, plrGun)
	
	local reload = humanoid.Animator:LoadAnimation(plrGun.reload)	

	reload:Play()
	reload:AdjustSpeed(gunStats[gunNumber][6])
	
end



UIS.InputBegan:Connect(function(I, E)
	if E then return end -- If you are typing you can't aim
	--print("aimed")

	if I.UserInputType == Enum.UserInputType.MouseButton2 and equipped == true and plr.Character.Humanoid.Health > 0 then
		
		aim(true)
		
	end
end)


UIS.InputEnded:Connect(function(I, E)
	if E then return end -- If you are typing you can't aim
	--print("stopped aiming")
	if I.UserInputType == Enum.UserInputType.MouseButton2 and equipped == true and plr.Character.Humanoid.Health > 0 then
		
		aim(false)

	end
end)	

-- SHOOT WEAPON FIRE GUN

UIS.InputBegan:Connect(function(I, E)
	if debounce == true then return end

	if E then return end -- If you are typing you can't shoot

	if I.UserInputType == Enum.UserInputType.MouseButton1 and equipped == true and plr.Character.Humanoid.Health > 0 then
		
		shoot()

	end
end)



UIS.InputEnded:Connect(function(I, E) -- Checks if the player is holding mouse, to allow automatic fire
	if E then return end

	if I.UserInputType == Enum.UserInputType.MouseButton1 then

		holdingMouse = false

	end
end)


-- RELOAD WEAPON

UIS.InputBegan:Connect(function(I, E)
	if E then return end -- If you are typing you can't shoot

	if I.KeyCode == Enum.KeyCode.R and equipped == true and plr.Character.Humanoid.Health > 0 then

		reload()

	end

end)

-- Mobile controls


-- Shoot gun
shootButton.MouseButton1Down:Connect(function()
	
	if equipped == true and plr.Character.Humanoid.Health > 0 then

		shoot()

	end
	
end)

shootButton.MouseButton1Up:Connect(function()
	
	holdingMouse = false
	
end)


-- Aim gun
aimButton.Activated:Connect(function()
	
	holdingRMB.Value = not holdingRMB.Value
	aim(holdingRMB.Value)
	
end)


-- Reload gun
reloadButton.Activated:Connect(function()
	
	reload()
	
end)


-- Handles aiming and automatic weapons

game:GetService("RunService").Stepped:Connect(function()
	if holdingRMB == false then
		ADSEvent:FireServer(false, plrGun)
	end

	if debounce == true then return end

	if holdingMouse == true and equipped == true and plr.Character.Humanoid.Health > 0 and gunStats[gunNumber][5] == 2 then
		shoot()
	end
end)


holdingRMB:GetPropertyChangedSignal("Value"):Connect(function()
	if plrGun == nil then return end
	ADSEvent:FireServer(false, plrGun)
end)
