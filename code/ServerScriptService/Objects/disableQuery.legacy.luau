local workspace = game:WaitForChild("Workspace")
local cs = game:GetService("CollectionService")

for i, child in pairs(cs:GetTagged("nonQueryPart")) do
	
	child.CanQuery = false
	
end
