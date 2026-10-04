local cs = game:GetService("CollectionService")
local plrTip = game:WaitForChild("ReplicatedStorage").plrTipsEvent
local ss = game:WaitForChild("ServerStorage")
local rs = game:WaitForChild("ReplicatedStorage")

local qte = rs.gameplayEvents.quickTimeEvent

local lockSound = script.lockSound

local function lockDoor(door) -- Changes the lock state of the door (unlocked or locked)
	
	local cloneSound = lockSound:Clone()
	cloneSound.Parent = door.door
	cloneSound:Destroy()
	
	if door.Locked.Value == true then
		door.Locked.Value = false
		door.lockDoorPart.lockDoorPrompt.ActionText = "Lock door"
	else
		door.Locked.Value = true
		door.lockDoorPart.lockDoorPrompt.ActionText = "Unlock door"
	end
	
end


for i, door in pairs (cs:GetTagged("singleDoor")) do

	door.lockDoorPart.lockDoorPrompt.Triggered:Connect(function(plr)
		
		if door:FindFirstChild("needsKey") == nil then -- If the door doesn't need a key 
			
			lockDoor(door)

		else
			
			if door.needsKey.Value == true then -- If the door needs a key
				
				local key = plr.Character:FindFirstChild("Key")
								
				if key == nil then 
					plrTip:FireClient(plr, "Equip a key!", 3)
					return 
				end
									
				if key.linkedDoor.Value ~= door then
					plrTip:FireClient(plr, "Wrong key", 3)
				else
					lockDoor(door)
				end
				
			else -- If the door doesn't needs a key
				
				lockDoor(door)
				
			end
			
		end
		
		
	end)

end
