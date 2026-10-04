repeat task.wait() until game.Players.LocalPlayer


local plr = game.Players.LocalPlayer
local character = plr.Character
local hum = character.Humanoid

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end

local fallDamage = game:WaitForChild("ReplicatedStorage").calculateFallDamage

-- Fall damage is recorded by player velocity when landing, not airtime

local jumpCooldown = 0.8
local isJumping = true
local fellHeight = character.HumanoidRootPart.Position.Y
local landHeight = character.HumanoidRootPart.Position.Y

local root = character:WaitForChild("HumanoidRootPart")


local fallTime = tick()
local airTime = 0

hum.StateChanged:Connect(function(oldState, newState)

	if newState == Enum.HumanoidStateType.Jumping then
		
		isJumping = true
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

		task.wait(jumpCooldown)
		
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end

	if newState == Enum.HumanoidStateType.Freefall then
		
		fallTime = tick()
		fellHeight = character.HumanoidRootPart.Position.Y
		
	end
	
	if newState == Enum.HumanoidStateType.Landed then
		
		landHeight = character.HumanoidRootPart.Position.Y
		local velocity = root.Velocity.Y -- vertical speed at landing (negative = down)

		if velocity < -75 then -- ignore small jumps
			fallDamage:FireServer(math.abs(velocity), fellHeight, landHeight) 
		end
		
	end

end)
