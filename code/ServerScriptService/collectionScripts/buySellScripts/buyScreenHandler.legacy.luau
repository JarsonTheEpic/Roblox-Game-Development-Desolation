local openBuyScreen = game:WaitForChild("ReplicatedStorage").gameplayEvents.openBuyScreen

local collectionService = game:GetService("CollectionService")


for i, point in pairs(collectionService:GetTagged("buyPoint")) do

	local prompt = point.promptPart.ProximityPrompt

	prompt.Triggered:Connect(function(plr)

		openBuyScreen:FireClient(plr, point.buyPointInfo.Value)

	end)

end