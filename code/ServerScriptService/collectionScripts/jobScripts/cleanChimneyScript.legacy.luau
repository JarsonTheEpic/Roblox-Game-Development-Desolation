local collectionService = game:GetService("CollectionService")

local cleanResetTimer = 5
local cleanChimneyMoney = 20

for i, chimney in pairs (collectionService:GetTagged("Chimneys")) do
	
	local smokePart = chimney.smokePart
	local cleanChimneyPrompt = chimney.cleanChimneyPromptPart.cleanChimneyPrompt

	cleanChimneyPrompt.Triggered:Connect(function(plr)

		local characterCheck = plr.Character:FindFirstChild("Broom")
		local backpackCheck = plr.Backpack:FindFirstChild("Broom")

		if characterCheck or backpackCheck and cleanResetTimer == 0 then
			
			cleanChimneyPrompt.Enabled = false

			smokePart.Smoke.Color = Color3.new(1, 1, 1)
			smokePart.Smoke.Opacity = 0.4
			
			plr.leaderstats.Coins.Value = plr.leaderstats.Coins.Value + cleanChimneyMoney

			cleanChimneyPrompt.Enabled = false
			
			wait(cleanResetTimer)
			
			cleanChimneyPrompt.Enabled = true

			smokePart.Smoke.Color = Color3.new(0, 0, 0)
			smokePart.Smoke.Opacity = 0.75
			
		end

	end)
	
end
