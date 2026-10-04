local collectionService = game:GetService("CollectionService")
local tweenService = game:GetService("TweenService")
local plrTips = game:WaitForChild("ReplicatedStorage").plrTipsEvent
local robAnimation = script.robAnimation
local broken = script.broken
local start = script.start
local successful = script.successful

local ss = game:WaitForChild("ServerStorage")
local rs = game:WaitForChild("ReplicatedStorage")
local robberyReset = ss.Events.robberyReset
local qte = rs.gameplayEvents.quickTimeEvent
local plrTip = rs.plrTipsEvent


local bountyValue = 50

local function robOpen(robbery, plr)
	
	local robPart = robbery.robPart
	local available = robPart.available
	
	if robPart:GetAttribute("robberyType") == "Register" then
		
		available.Value = false
		
		plr.playerstats.Bounty.Value += 50
		
		local cashDrawer = robbery.cashDrawer
		local goal = {CFrame = robbery.endPos.CFrame}
		local info = TweenInfo.new(0.4, Enum.EasingStyle.Bounce)
		local open = tweenService:Create(cashDrawer, info, goal)
		
		open:Play()
		
		robberyReset:Fire(robbery, 180)
		
		
	elseif robPart:GetAttribute("robberyType") == "Safe" then
		
		local lockpick = plr.Character:FindFirstChild("Lockpick", true)

		if lockpick == nil then

			plrTip:FireClient(plr, "You need a lockpick to open this!", 3)
			return

		end
		
		
		local success, err = pcall(function()

			if qte:InvokeClient(plr, 0.6, math.random(10, 90) / 100, 0.2, 0.85) then	-- If the player succeeded the qte

				plr.playerstats.Bounty.Value += 100
				plrTip:FireClient(plr, "Lock successfully picked!", 3)

				local lockSoundClone = script.lockSound:Clone()
				lockSoundClone.Parent = robPart
				lockSoundClone:Remove()
				
				local hinge = robbery.hinge
				local goal = {CFrame = hinge.CFrame * CFrame.Angles(math.rad(110), 0, 0)}
				local info = TweenInfo.new(1, Enum.EasingStyle.Sine)
				local open = tweenService:Create(hinge, info, goal)
				
				open:Play()
				
				robberyReset:Fire(robbery, 360)
				
				available.Value = false

			else	-- Otherwise

				plrTip:FireClient(plr, "Lockpick failed", 3)

				local lockpickSoundClone = script.lockpickFailSound:Clone()
				lockpickSoundClone.Parent = robPart
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
		
		
	end
	
end

for i, part in pairs(collectionService:GetTagged("robParts")) do
	
	local prompt = part.robPrompt
	local available = part.available
	local cooldown = part.cooldown
	
	prompt.PromptButtonHoldBegan:Connect(function(plr)

		local char = plr.Character
		local hum = char.Humanoid
		local animTrack = hum:LoadAnimation(robAnimation)
		animTrack:Play()
		animTrack:AdjustSpeed(0.45)
		
		start:Play()

		prompt.PromptButtonHoldEnded:Connect(function(plr)

			animTrack:Stop()

		end)

	end)
	
	prompt.Triggered:Connect(function(plr)
		
		local cloneBroken = broken:Clone()
		cloneBroken.Parent = prompt
		cloneBroken:Destroy()

		
		if available.Value == true then
						
			--local robValue = part.robCash.Value
			--robValue += math.random(-10, 10)
			--plr.leaderstats.Crons.Value += robValue
			--plrTips:FireClient(plr, "You robbed ".. robValue.. " Crons from the cash register!", 3)
			robOpen(part.Parent, plr)
						
		else
			
			plrTips:FireClient(plr, "This has already been robbed!", 3)
			
		end
		
		
	end)
	
end
