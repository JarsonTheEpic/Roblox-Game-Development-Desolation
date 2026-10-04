local rs = game:WaitForChild("ReplicatedStorage")
local mps = game:WaitForChild("MarketplaceService")
local cs = game:GetService("CollectionService")

local plrTipEvent = rs.plrTipsEvent

local workAnimation = script.workAnimation

local DOUBLE_WAGE_ID = 1691059548

for i, work in pairs(cs:GetTagged("workPart")) do
	
	local prompt = work.workPrompt
	local workSound = work.workSound
	local finishSound = work.finishSound
	
	local track = nil
	
	prompt.PromptButtonHoldBegan:Connect(function(plr)
		
		local char = plr.Character
		local hum = char:WaitForChild("Humanoid")
		
		local animator = hum:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = hum
		end
		
		track = animator:LoadAnimation(workAnimation)
		track:Play()
		workSound:Play()
		
	end)
	
	prompt.PromptButtonHoldEnded:Connect(function(plr) -- Stops the animation when the prompt stops being held
		
		if track then
			track:Stop()
		end
		
		workSound:Stop()
		
	end)
	
	prompt.Triggered:Connect(function(plr) -- Gives money for working
		local reward = work:GetAttribute("reward")
		
		-- Checks if the player owns the double wage gamepass
		local hasPass = false
		local success, err = pcall(function()

			hasPass = mps:UserOwnsGamePassAsync(plr.UserId, DOUBLE_WAGE_ID)

		end)
		if hasPass then
			reward *= 2
		end
		
		plr.leaderstats.Crons.Value += reward
		plrTipEvent:FireClient(plr, "You got paid".. reward.. " Crons for working", 3)
		
		if track then
			track:Stop()
		end
		
		workSound:Stop()
		finishSound:Play()
	end)
	
end
