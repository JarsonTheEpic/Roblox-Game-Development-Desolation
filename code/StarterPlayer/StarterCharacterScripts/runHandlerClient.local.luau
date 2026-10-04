wait(1)

repeat task.wait() until game.Players.LocalPlayer

if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end


local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local cam = game.Workspace.Camera

local walkSpeed = 10
local runSpeed = 22
local running = false

local UIS = game:GetService("UserInputService")
local isRunningEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.runEvent
local updateSpeed = game:WaitForChild("ReplicatedStorage").gameplayEvents.updateSpeedEvent

local walkSpeedMultiplier = plr:WaitForChild("walkSpeedMultiplier")
local isRunning = plr:WaitForChild("isRunning")


local runButton = plr.PlayerGui.mobileControls.runGui.runButton

function updateInput()
	local lastInput = UIS:GetLastInputType()
	if lastInput == Enum.UserInputType.Focus then return end -- ignore if the player focuses on the app
	plr.PlayerGui.mobileControls.runGui.Enabled = lastInput == Enum.UserInputType.Touch -- makes the frame visible if the user touched the screen
end


updateInput()
UIS.LastInputTypeChanged:Connect(updateInput)



local function startRunning(isRunning)
	
	if isRunning then
		if running == true then return end  -- If already running then skip the input, stops multiple inputs

		for count = 1, 5 do
			wait()
			cam.FieldOfView = cam.FieldOfView + 3
		end
		
		running = true
		
		--runButton.ImageColor3 = Color3.new(175, 175, 175)
		
		isRunningEvent:FireServer(true)
		
	else
		if running == false then return end
		
		for count = 1, 5 do
			wait()
			cam.FieldOfView = cam.FieldOfView - 3
		end
		
		running = false
		
		--runButton.ImageColor3 = Color3.new(255, 255, 255)

		isRunningEvent:FireServer(false)
		
	end
	
end


--humanoid.WalkSpeed = walkSpeed * walkSpeedMultiplier.Value
isRunningEvent:FireServer(false)
updateSpeed:FireServer(nil, false)

--walkSpeedMultiplier:GetPropertyChangedSignal("Value"):Connect(function()
--	updateSpeed:FireServer()
--end)

UIS.InputBegan:Connect(function(input, gameProcessed, IsTyping)

	if IsTyping then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		
		startRunning(true)

	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed, IsTyping)

	if IsTyping then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		
		startRunning(false)

	end
end)


runButton.Activated:Connect(function()
	
	if running == false then
		startRunning(true)
	else
		startRunning(false)
	end
	
end)


plr.Character.ChildAdded:Connect(function(child)

	if child:IsA("Tool") == false then return end
	updateSpeed:FireServer(child, true)
	
end)

plr.Character.ChildRemoved:Connect(function(child)

	if child:IsA("Tool") == false then return end
	updateSpeed:FireServer(child, false)

end)