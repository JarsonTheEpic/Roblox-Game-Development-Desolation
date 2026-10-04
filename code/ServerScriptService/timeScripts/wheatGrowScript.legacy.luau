local css = game:WaitForChild("CollectionService")
local models = game:WaitForChild("ReplicatedStorage").models
local growChance = 75
local wheatFarm = game:WaitForChild("Workspace").Minito["Wheat farm"]
local growTime = 60

local function growWheat(wheat)
	if wheat.Name == "wheat3" then
		return
	elseif wheat.Name == "wheat1" then
		wheat.Name = "wheat2"
		wheat.Size = models.wheat2.Size
		wheat.BrickColor = models.wheat2.BrickColor
	else
		wheat.Name = "wheat3"
		wheat.Size = models.wheat3.Size
		wheat.BrickColor = models.wheat3.BrickColor
	end
end

while true do
	
	task.wait(growTime)
	for i, wheat in pairs(css:GetTagged("wheat")) do
		
		if math.random(1, 100) < growChance then
			growWheat(wheat)
		end
		
	end
	
end
