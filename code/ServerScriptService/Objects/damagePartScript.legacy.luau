local playerService = game:GetService("Players")
local cs = game:GetService("CollectionService")

for i, damagePart in pairs (cs:GetTagged("damagePart")) do
	
	damagePart.Touched:Connect(function(hit)
		
		local damage = damagePart:GetAttribute("damage")

		if hit.Parent:FindFirstChild("Humanoid") then

			hit.Parent.Humanoid.Health -= damage

			wait()

			local plr = playerService:GetPlayerFromCharacter(hit.Parent)

		end

	end)

	
end

