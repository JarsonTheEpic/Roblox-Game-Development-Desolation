local tweenservice = game:GetService("TweenService")
local collectionService = game:GetService("CollectionService")

local plrTip = game:WaitForChild("ReplicatedStorage").plrTipsEvent
local qte = game.ReplicatedStorage.gameplayEvents.quickTimeEvent

local OPEN_ANGLE = 90
local OPEN_TIME = 0.35

-- If you dont want the door to have locks then just remove the lock prompt
local function openDoor(Door, Locked, plr)
	
	local hinge = Door.hinge
	local proximityPrompt = Door.door.openDoorPrompt
	
	local goalOpen = {}
	goalOpen.CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(-OPEN_ANGLE), 0)

	local goalClose = {}
	goalClose.CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(OPEN_ANGLE), 0)

	local tweenInfo = TweenInfo.new(OPEN_TIME, Enum.EasingStyle.Sine)
	local tweenOpen = tweenservice:Create(hinge, tweenInfo, goalOpen)
	local tweenClose = tweenservice:Create(hinge, tweenInfo, goalClose)
	
	if proximityPrompt.ActionText == "Close" then -- The player can close the door even if its locked
		
		local newCloseSound = script.doorClose:Clone()
		newCloseSound.Parent = Door.door
		newCloseSound:Remove()
		
		tweenClose:play()
		
		proximityPrompt.ActionText = "Open"
		
	elseif proximityPrompt.ActionText == "Open" then
		
		if Locked then -- If its locked, start QTE if the player has lockpick
			
			local lockpick = plr.Character:FindFirstChild("Lockpick", true)
			
			if lockpick == nil then
				
				plrTip:FireClient(plr, "Door is locked! (You can try using a lockpick)", 3)
				
				task.wait(OPEN_TIME + 0.05)
				proximityPrompt.Enabled = true
				return
				
			end
			
			if lockpick.toolStats.amount.Value <= 0 then return end -- Won't start the lockpicking process if amount is 0
			
			local success, err = pcall(function()
				
				if qte:InvokeClient(plr, 0.6, math.random(10, 90) / 100, 0.2, 0.85) then	-- If the player succeeded the qte

					plrTip:FireClient(plr, "Lock successfully picked!", 3)

					Door.Locked.Value = false -- Unlocks the door, and changes the prompt message
					Door.lockDoorPart.lockDoorPrompt.ActionText = "Lock door"

					local lockSoundClone = script.lockSound:Clone()
					lockSoundClone.Parent = Door.door
					lockSoundClone:Remove()

				else	-- otherwise

					plrTip:FireClient(plr, "Lockpick failed", 3)

					local lockpickSoundClone = script.lockpickFailSound:Clone()
					lockpickSoundClone.Parent = Door.door
					lockpickSoundClone:Remove()

				end
				
				lockpick.toolStats.amount.Value -= 1
				if lockpick.toolStats.amount.Value <= 0 then -- After deducting amount, the lockpick tool is destroyed if theres no more left
					
					lockpick:Destroy()
					
				end
				
			end)
			
			if not success then
				
				warn("QTE invoke failed; reason: ", err)
				
			end
			
			
			
		else

			local newOpenSound = script.doorOpen:Clone()
			newOpenSound.Parent = Door.door
			newOpenSound:Remove()

			tweenOpen:Play()
			proximityPrompt.ActionText = "Close"
			
		end
		
	end
	
	task.wait(OPEN_TIME + 0.05)
	proximityPrompt.Enabled = true
	
end

for i, Door in pairs(collectionService:GetTagged("singleDoor")) do

	local hinge = Door.hinge
	local proximityPrompt = Door.door.openDoorPrompt
	local locked = Door.Locked
	
	for i, child in pairs(Door.door:GetChildren()) do
		
		if child.Name == "doorHandle" then
			child.CanCollide = false
			child.CanTouch = false
			child.CanQuery = false
		end
		
	end
	
	
	proximityPrompt.Triggered:Connect(function(plr)
		
		proximityPrompt.Enabled = false
		
		task.wait(0.01)
		openDoor(Door, locked.Value, plr)
		
	end)
	
end