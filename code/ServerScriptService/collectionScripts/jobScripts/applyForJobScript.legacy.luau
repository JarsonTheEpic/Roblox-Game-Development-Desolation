local collectionService = game:GetService("CollectionService")
local plrTipEvent = game:WaitForChild("ReplicatedStorage").plrTipsEvent

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


for	i, job in pairs(collectionService:GetTagged("jobs")) do
	
	local proximityPrompt = job.applyForJobPrompt
	local selectedJob = jobList[job.jobName.Value]
	local fee = selectedJob.fee
	local jobName = selectedJob.jobName
	local salary = selectedJob.salary
	local requiredStats = selectedJob.requiredStats
	
	proximityPrompt.Triggered:Connect(function(plr)
		
		task.wait()

		local plrJob = plr.playerstats.Occupation
		local plrCrons = plr.leaderstats.Crons
		local jobCheck = true
		
		print(plrJob)
		print(fee)
		print(plrJob.Value)
		print(plrCrons.Value)
		
		if plr.playerstats.Charisma.Value < requiredStats.Charisma[2] then
			jobCheck = false
			plrTipEvent:FireClient(plr, "You are not charismatic enough.", 3)
		elseif plr.playerstats.Stamina.Value < requiredStats.Stamina[2] then
			jobCheck = false
			plrTipEvent:FireClient(plr, "You don't have enough stamina.", 3)
		elseif plr.playerstats.Sanity.Value < requiredStats.Sanity[2] then
			jobCheck = false
			plrTipEvent:FireClient(plr, "You are not sane.", 3)
		elseif plr.playerstats.Hygiene.Value < requiredStats.Hygiene[2] then
			jobCheck = false
			plrTipEvent:FireClient(plr, "You are not clean enough.", 3)
		end
		
		if plrJob.Value == "Unemployed" and plrCrons.Value > fee and jobCheck == true then
			
			plrCrons.Value = plrCrons.Value - fee

			plrTipEvent:FireClient(plr, "You became a ".. jobName.. "!".. "Check your phone to track your job status", 4)

			plrJob.Value = jobName
			plr.Quota.Value = 0
			plr.joinedTime.Value = game:GetService("Lighting").ClockTime
			plr.joinedTime2.Value = plr.joinedTime.Value + 0.5

		else

			if plrJob.Value == jobName then

				plrTipEvent:FireClient(plr, "You are already a " .. jobName.. "!", 3)
				
			elseif plrJob.Value ~= "Unemployed" then
				
				plrTipEvent:FireClient(plr, "You must resign from your current job to apply for this job!", 3)
				
			end
			
			if plrCrons.Value < fee then
				
				plrTipEvent:FireClient(plr, "You don't have enough Crons to apply for this job!", 3)
				task.wait(1.5)
				plrTipEvent:FireClient(plr, "You need atleast".. fee.. "To apply", 3)

			end

		end

	end)
	
end
