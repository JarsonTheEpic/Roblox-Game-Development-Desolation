local css = game:WaitForChild("CollectionService")
local rs = game:WaitForChild("ReplicatedStorage")
local ss = game:WaitForChild("ServerStorage")

local models = rs.models
local plrTipsEvent = rs.plrTipsEvent
local waypointEvent = rs.gameplayEvents.createWaypoint
local waypointArrow = rs.waypointArrow


local wheatFarm = game:WaitForChild("Workspace").Minito["Wheat farm"]
local wheatTool = ss:FindFirstChild("Wheat", true)



for i, wheat in css:GetTagged("wheat") do
	local prom = Instance.new("ProximityPrompt")
	prom.Parent = wheat
	prom.ActionText = "Collect"
	prom.ObjectText = "Wheat"
	prom.HoldDuration = 2
	prom.Triggered:Connect(function(plr)
		if wheat.Name ~= "wheat3" then
			plrTipsEvent:FireClient(plr, "Wheat not fully grown yet", 3)
			return
		end
		
		wheat.Name = "wheat1"
		wheat.Size = models.wheat1.Size
		wheat.BrickColor = models.wheat1.BrickColor
		
		local search = plr.Character:FindFirstChild("Wheat")
		if search == nil then 
			search = plr.Backpack:FindFirstChild("Wheat")
		end

		if search == nil then
			local cloneWheat = wheatTool:Clone()
			cloneWheat.Parent = plr.Backpack
			cloneWheat.Name = "Wheat"
		else
			search.toolStats.amount.Value += 1
		end
		
		waypointEvent:FireClient(plr, true, wheatFarm:FindFirstChild("wheatPart", 1).Position)
		
		
		plrTipsEvent:FireClient(plr, "You collected a sheaf of wheat", 3)
		
	end)
end
