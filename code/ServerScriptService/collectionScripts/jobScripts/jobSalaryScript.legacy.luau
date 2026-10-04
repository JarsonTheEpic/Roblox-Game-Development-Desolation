local jobList = {
	wheatFarmer = { 
		jobName = "Wheat farmer",
		salary = 35, -- Crons per day
		fee = 0, -- How much you need to apply for the job
		quota = 5,
		requiredStats = {
			Charisma = {"Charisma", 0},
			Stamina = {"Stamina", 0},
			Sanity = {"Sanity", 0},
			Hygiene = {"Hygiene", 30}
		}
	},
	weaponFactoryWorker = {
		jobName = "Weapon factory worker",
		salary = 35,
		fee = 0,
		quota = 8,
		requiredStats = {
			Charisma = {"Charisma", 0},
			Stamina = {"Stamina", 75},
			Sanity = {"Sanity", 60},
			Hygiene = {"Hygiene", 5}
		}
	}
}

local gameTime = game.Lighting.ClockTime
local plrTipEvent = game:WaitForChild("ReplicatedStorage").plrTipsEvent
local mps = game:GetService("MarketplaceService")

-- local doubleWagesID = 256425860

game.Players.PlayerAdded:Connect(function(plr)
	
	repeat task.wait() until plr.playerstats
	
	local plrOccupation = plr.playerstats.Occupation
	local plrCrons = plr.leaderstats.Crons
	
	local Paid = false
	
	task.wait(30)
	
	while plr do
		
		task.wait()
		
		gameTime = game.Lighting.ClockTime
		
		if gameTime >= plr.joinedTime.Value and gameTime < plr.joinedTime2.Value then
			
			for i, job in pairs(jobList) do
				if plrOccupation.Value == job.jobName and Paid == false and plr.Quota.Value >= job.quota then		
					plr.Quota.Value = 0
					Paid = true
					local hasPass = false
						
					--local success, errorMessage = pcall(function()
					--	hasPass = mps:UserOwnsGamePassAsync(plr.UserId, doubleWagesID)
					--end)
						
					if hasPass == true then
							
						plrCrons.Value = plrCrons.Value + 2 * (job[2])
							
					elseif hasPass == false then
							
						local msg = "You received a paycheck of ".. job.salary.. " Crons!"
						plrTipEvent:FireClient(plr, msg, 3)
						plrCrons.Value = plrCrons.Value + job.salary
							
					end
					
					task.wait(60)
					Paid = false	
					
				elseif plr.Quota.Value < job.quota then
					
					local msg = "You have not completed your quota today."
					plrTipEvent:FireClient(plr, msg, 3)
					plr.Quota.Value = 0
					task.wait(60)
					
				end
			end

		end
		
	end
	
end)