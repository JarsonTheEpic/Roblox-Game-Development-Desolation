local cs = game:GetService("CollectionService")
local tweenService = game:GetService("TweenService")


local OPEN_TIME = 4.5

local function openDoor(garageDoor)
	
	local prompt = garageDoor.button.ProximityPrompt
	local startPos = garageDoor.startPos
	local endPos = garageDoor.endPos
	local door = garageDoor.door
	
	if prompt.ActionText == "Open" then
		-- Opens the door
		local goal = {
			Position = endPos.Position,
			Size = endPos.Size
		}
		
		door.doorOpen:Play()
		
		local info = TweenInfo.new(OPEN_TIME, Enum.EasingStyle.Sine)
		local tween = tweenService:Create(door, info, goal)
		tween:Play()
		tween.Completed:Wait()
		
		-- Changes action text
		prompt.ActionText = "Close"
	else
		-- Closes the door
		local goal = {
			Position = startPos.Position,
			Size = startPos.Size
		}
		
		door.doorClose:Play()

		local info = TweenInfo.new(OPEN_TIME, Enum.EasingStyle.Sine)
		local tween = tweenService:Create(door, info, goal)
		tween:Play()
		tween.Completed:Wait()
		
		-- Changes action text
		prompt.ActionText = "Open"
	end
	
	prompt.Enabled = true
	
end


for i, garageDoor in pairs(cs:GetTagged("garageDoor")) do
	
	local prompt = garageDoor.button.ProximityPrompt
	
	prompt.Triggered:Connect(function(plr)
		
		prompt.Enabled = false
		task.wait(0.01)
		
		openDoor(garageDoor)
		
	end)
	
end