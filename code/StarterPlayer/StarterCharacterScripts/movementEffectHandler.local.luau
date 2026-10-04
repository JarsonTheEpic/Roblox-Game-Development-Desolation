local run = game:GetService("RunService")

repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local camera = workspace.CurrentCamera
local DefaultSpeed = game:GetService("StarterPlayer").CharacterWalkSpeed

local SHAKE_STRENGTH = 0.006
local MAX_SPEED = 30
local X_MODIFIER = 0.55
local Y_MODIFIER = 0.8
local Z_MODIFIER = 0.028

local WALK_DIVISOR = DefaultSpeed / 1.7
local SWIMMING_DIVISOR = DefaultSpeed / 1.6
local CLIMBING_DIVISOR = DefaultSpeed / 1

-- Camera shake effect while moving

run.RenderStepped:Connect(function()
	
	-- If the camera is not in the default mode, then don't have any effects
	if camera.CameraType ~= Enum.CameraType.Custom then return end
	
	-- Detects player movement speed
	local speed = hum.MoveDirection.Magnitude * hum.WalkSpeed
	
	--local speed = char.HumanoidRootPart.AssemblyLinearVelocity.Magnitude
	--print(speed)
	--if speed < 9 then -- Deadzone
	--	speed = 0
	--end
	speed = math.clamp(speed, 0, MAX_SPEED)
	
	local randomModifier = math.random(60, 100) / 100
	
	local runningMultiplier = 1
	if speed >= 12 then
		runningMultiplier = 2
	end
	
	-- Reduces shake effect if player is in third person

	local thirdPersonMultipler = 0.8
	if char.Head.LocalTransparencyModifier > 0.5 then -- If player is in first person
		thirdPersonMultipler = 1
	end
	
	local shakeX = math.sin(tick() * 7 * runningMultiplier) * SHAKE_STRENGTH * speed * X_MODIFIER * randomModifier * thirdPersonMultipler
	local shakeY = math.sin(tick() * 14 * runningMultiplier) * SHAKE_STRENGTH * speed * Y_MODIFIER * randomModifier * thirdPersonMultipler
	local shakeZ = math.sin(tick() * 5 * runningMultiplier) * SHAKE_STRENGTH * speed * Z_MODIFIER * randomModifier * thirdPersonMultipler * 0.5
	
	if runningMultiplier == 2 then -- If player is running, angular displacement is more intense
		shakeZ = math.sin(tick() * 9 * runningMultiplier) * SHAKE_STRENGTH * speed * Z_MODIFIER * randomModifier * thirdPersonMultipler
	end
	
	camera.CFrame = camera.CFrame * CFrame.new(shakeX, shakeY, 0) -- Displacement of camera
	camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, shakeZ) -- Angular Displacement of camer
	
end)


-- Syncs walk sound to player speed 
hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	
	local WalkSpeed = hum.WalkSpeed
	root.Running.PlaybackSpeed = WalkSpeed / WALK_DIVISOR
	root.Swimming.PlaybackSpeed = WalkSpeed / SWIMMING_DIVISOR
	root.Climbing.PlaybackSpeed = WalkSpeed / CLIMBING_DIVISOR
	
end)
