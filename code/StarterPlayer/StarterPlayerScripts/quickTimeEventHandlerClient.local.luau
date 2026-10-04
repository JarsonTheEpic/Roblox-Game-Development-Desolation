local quickTime = game:WaitForChild("ReplicatedStorage").gameplayEvents.quickTimeEvent
local uis = game:GetService("UserInputService")

repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer


local qtGui = plr.PlayerGui:WaitForChild("quickTimeEvent")
local bar = qtGui.Frame.bar
local goal = bar.goal
local cursor = bar.cursor
local button = qtGui.Frame.interactButton

local inputCon


quickTime.OnClientInvoke = function(waitTime, goalPos, goalSize, timer)
	
	-- timer: how many seconds does it take to travel the whole of bar
	
	goal.Size = UDim2.new(goalSize, 0, goal.Size.Y.Scale, 0)
	goal.Position = UDim2.new(goalPos, 0, goal.Position.Y.Scale, 0)
	
	cursor.Position = UDim2.new(0, 0, cursor.Position.Y.Scale, 0) -- Initialises the cursor position
	
	button.Active = true -- Initialises the button
	
	qtGui.Enabled = true
	task.wait(waitTime)
	
	local clickedPos = nil
	
	task.spawn(function() -- This function displays the animation of the cursor moving across the bar
		
		for i = 0, 100, 1 do -- Increments the cursor position by 1/100th of the bar each time
			
			task.wait(timer / 100)
			
			cursor.Position = UDim2.new(i / 100, 0, cursor.Position.Y.Scale, 0) -- Sets the new position of the cursor
			
			if clickedPos then -- If the player clicked, then break
				break
			end
			
		end
		
		-- If the player didn't click, then they automatically fail the quick time event
				
		clickedPos = 100 -- Sets the clickpos to an obviously wrong one, to fail the event
		
	end)
	
	button.Activated:Connect(function() -- Listens for button press
		
		button.Active = false
		clickedPos = cursor.Position.X.Scale
		
	end)
	
	inputCon = uis.InputBegan:Connect(function(input, gameProcessed) -- Listens for key press

		if gameProcessed then return end
		if not button.Active then return end

		-- Allowed inputs
		if input.KeyCode == Enum.KeyCode.E then

			button.Active = false
			clickedPos = cursor.Position.X.Scale
			return true

		end

	end)
	
	
	repeat task.wait() until clickedPos -- Wait until the click position is set
	
	
	qtGui.Enabled = false
	
	if clickedPos >= goalPos - (goalSize / 2) and clickedPos <= goalPos + (goalSize / 2) then -- If the click position is within the goal
		
		return true
		
	else
			
		return false
		
	end
	
	
end
