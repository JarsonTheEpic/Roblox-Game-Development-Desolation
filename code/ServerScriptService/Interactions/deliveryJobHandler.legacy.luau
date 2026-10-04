local cs = game:GetService("CollectionService")
local rs = game:WaitForChild("ReplicatedStorage")
local ss = game:WaitForChild("ServerStorage")
local mps = game:GetService("MarketplaceService")

local deliveryJobEvent = rs:WaitForChild("gameplayEvents").deliveryJobEvent
local plrTipsEvent = rs.plrTipsEvent
local waypointEvent = rs.gameplayEvents.createWaypoint

local waypointArrow = rs.waypointArrow
local supplyBox = ss.Tools.Other["Supply box"]

local CRONS_REWARD = 10
local DOUBLE_WAGE_ID = 1691059548


for i, job in pairs(cs:GetTagged("deliveryJob")) do
	
	local prompt = job.deliveryPrompt
	local points = job.Parent.turnInPoints
	
	prompt.Triggered:Connect(function(plr)
		
		local box = plr.Backpack:FindFirstChild("Supply box") or plr.Character:FindFirstChild("Supply box")
		if box then
			plrTipsEvent:FireClient(plr, "You already have a box!", 3)
			return
		end
		
		local randomPoint = points:GetChildren()[math.random(1, #points:GetChildren())] -- Generates a random ID of the turn in points
		
		box = supplyBox:Clone()
		box.toolStats.turnInPoint.Value = randomPoint -- assigns a turn in point for the supply box
		box.Parent = plr.Backpack
		
		local hum = plr.Character:FindFirstChild("Humanoid")
		if hum then -- Force equips the box
			hum:EquipTool(box)
		end
		
		plrTipsEvent:FireClient(plr, "Deliver the box to the location shown by the arrow!", 3)
		
		deliveryJobEvent:FireClient(plr, randomPoint, true) -- Enables the turn in prompt on the client side
		waypointEvent:FireClient(plr, true, randomPoint.Position) -- Generates a waypoint arrow to the position
		
	end)
	
	
	for i, point in pairs(points:GetChildren()) do
		
		local turnInPrompt = point.turnInPrompt
		turnInPrompt.Triggered:Connect(function(plr)
			
			local reward = CRONS_REWARD
			
			local box = plr.Backpack:FindFirstChild("Supply box") or plr.Character:FindFirstChild("Supply box")
			if not box then
				plrTipsEvent:FireClient(plr, "You don't have a box!", 3)
				return
			end
			
			if box.toolStats.turnInPoint.Value ~= point then -- If it's the wrong turn in point
				plrTipsEvent:FireClient(plr, "This is the wrong place to turn in this box!", 3)
				return
			end
			
			-- Checks if the player owns the double wage gamepass
			local hasPass = false
			local success, err = pcall(function()

				hasPass = mps:UserOwnsGamePassAsync(plr.UserId, DOUBLE_WAGE_ID)

			end)
			if hasPass then
				reward *= 2
			end
			
			box:Destroy()
			
			plr.leaderstats.Crons.Value += reward
			deliveryJobEvent:FireClient(plr, point, false) -- Disables the turn in prompt on the client side
			waypointEvent:FireClient(plr, false, nil) -- deletes the waypoint arrow
			
		end)
		
	end
	
end
