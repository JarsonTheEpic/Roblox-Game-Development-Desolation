local rs = game:WaitForChild("ReplicatedStorage")
local ss = game:WaitForChild("ServerStorage")
local cs = game:WaitForChild("CollectionService")

local Heartbeat = game:GetService("RunService").Heartbeat


local throw = rs.gameplayEvents.throw
local doorExplode = ss.Events.doorExplode
local partDestroy = ss.Events.partDestroy


local LeftDown = false

local players = game:GetService("Players")


local grenadeStats = {
	["Smoke grenade"] = {
		name = "Smoke grenade",
		throwVelocity = 120,
		jumpMultiplier = 1.2,
		
		grenadeFunction = function(grenade, plr)
			wait(1)
			grenade.Fuse:Play()
			grenade.Smoke1.Enabled = true
			wait(30)
			grenade.Fuse:Stop()
			grenade.Smoke1.Enabled = false
			wait(3)
			grenade:Destroy()
		end
	},
	C4 = {
		name = "C4",
		throwVelocity = 25,
		jumpMultiplier = 1.2,
		
		grenadeFunction = function(grenade, plr)
			
			if plr then
				plr.playerstats.Bounty.Value += 75 -- The player earns bounty by placing a C4 (Obviously)
			end
			
			local delayTime = 0.4 -- Initial delay between beep
			local fuse = grenade.Fuse
			
			local startTime = tick()
			
			for i = 0, 30, 1 do -- Plays the beep sound X times for tuffness, each time getting LOUDER

				task.wait(delayTime)
				
				local cloneFuse = fuse:Clone() -- The sounds are cloned since one sound wont play if its keep getting activated in before the sound ends
				cloneFuse.PlayOnRemove = true
				cloneFuse.Parent = grenade
				cloneFuse:Destroy()
								
				--grenade.Fuse.Volume += 0.1
				if delayTime > 0.16 then -- Minimum delay time
					delayTime *= 0.95
				end
				
			end
			
			print("Time taken for C4 to explode:".. tick() - startTime)
			grenade.Explode:Play() -- BOOOOM explodes
			
			task.spawn(function() -- Creates the smoke effect
				grenade.Smoke.Enabled = true
				task.wait(2)
				grenade.Smoke.Enabled = false
			end)
			
			
			local radius = 50			
			
			local detectionParams = OverlapParams.new()
			detectionParams.FilterType = Enum.RaycastFilterType.Exclude
			detectionParams.FilterDescendantsInstances = {grenade}
			
			local nearby = workspace:GetPartBoundsInRadius(grenade.Position, radius, detectionParams)
			
			local alreadyDamaged = {} -- Table to check if the Character has already been damaged
			
			local params =  RaycastParams.new() -- Sets raycast parameters
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = {grenade, grenade:GetChildren()}
			params.IgnoreWater = true
			
			for i, part in pairs(nearby) do
				local character = part:FindFirstAncestorOfClass("Model")
				
				if character and character:FindFirstChild("Humanoid") then -- Only looks for HumanoidRootPart

					local direction = (part.Position - grenade.Position).unit * 1000

					local results = workspace:Raycast(grenade.Position, direction, params)
					if results.Instance.Parent ~= character then continue end -- continues if the raycast hits a wall
					
					
					if table.find(alreadyDamaged, character) then continue end -- Checks if the humanoid has already taken damage
					
					table.insert(alreadyDamaged, character)
					
					local hum = character.Humanoid
					local distance = (grenade.Position - character.HumanoidRootPart.Position).Magnitude
					local damage = 500 - distance * 10 -- X maximum damage, loses Y damage every stud away from the bomb
					
					if damage > 0 then
						hum:TakeDamage(damage)
					end
					
				end
				
			end
			
			
			alreadyDamaged = {}
			local doorDestructionRadius = radius * 1
			local nearby = workspace:GetPartBoundsInRadius(grenade.Position, doorDestructionRadius, detectionParams)
			for i, part in pairs(nearby) do
				
				local door = part:FindFirstAncestorOfClass("Model")
				
				if part.Name == "vaultDoor" or cs:HasTag(door, "singleDoor") then -- Blows up doors and vault doors
					
					if door:FindFirstChild("available") then
						if door.available.Value == false then continue end
					end
					
					local direction = (part.Position - grenade.Position).unit * 1000

					local results = workspace:Raycast(grenade.Position, direction, params)
					
					if results.Instance.Parent ~= door then 
						continue 
					end -- continues if the raycast hits a wall, so the C4 can't blow up doors through walls
					
					
					if table.find(alreadyDamaged, door) then 
						continue 
					end -- The door already blew up
					table.insert(alreadyDamaged, door)

					task.spawn(function()
						if cs:HasTag(door, "singleDoor") then -- If its a door, then add a "destroyed" bool value flag to it so it can't be blown up again

							if door:FindFirstChild("destroyed") then
								print("Door is already destroyed")
								return
							end

							local destroyed = Instance.new("BoolValue")
							destroyed.Name = "destroyed"
							destroyed.Value = true

							destroyed.Parent = door
						end
						
						doorExplode:Fire(door)
					end)

				end
				
				task.spawn(function()					
					partDestroy:Fire(part, 30) -- Destroys the part IF it can be destroyed
				end)
				
			end
			

			local explosion = Instance.new("Explosion") -- Creates the explosion effect
			explosion.BlastPressure = 400000 -- The explosion effect must be after the calculation, or the door won't be blasted
			explosion.DestroyJointRadiusPercent = 0
			explosion.BlastRadius = radius
			explosion.ExplosionType = Enum.ExplosionType.NoCraters
			explosion.Position = grenade.Position
			explosion.Parent = grenade
			
			task.wait(2.5)
			
			grenade:Destroy()
		end
	},
	
}


function Toss(plr, direction, tool)
	local amount = tool.toolStats.amount
	
	if amount.Value > 0 then
		amount.Value -= 1
	else 
		return
	end
	
	local handlePos = Vector3.new(tool.Handle.Position.X, 0, tool.Handle.Position.Z)
	local spawnPos = plr.Character.Head.Position
	spawnPos  = spawnPos + (direction * 5)
	tool.Handle.Transparency = 1
	
	
	local velocity = grenadeStats[tool.Name].throwVelocity
	local arc = 5
	
	if plr.Character.Humanoid.WalkSpeed / 14 > 1 then
		velocity = velocity * (plr.Character.Humanoid.WalkSpeed / 14)
	end
	
	if plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall or plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
		velocity = velocity * grenadeStats[tool.Name].jumpMultiplier
		arc = 2
	end
		
	
	
	local Object = tool.Handle:Clone()
	Object.Parent = workspace
	Object.Transparency = 1
	Object.Swing.Pitch = math.random(90, 110)/100
	Object.Swing:Play()
	Object.CanCollide = true
	Object.CanTouch = true
	Object.Position = spawnPos
	Object.Velocity = (direction * velocity) + Vector3.new(0, velocity / arc, 0)
	Object.Trail.Enabled = true
	--Object.Sparks.Enabled = true
	local rand = velocity / 10
	Object.RotVelocity = Vector3.new(math.random(-rand,rand),math.random(-rand,rand),math.random(-rand,rand))
	Object:SetNetworkOwner(plr)
	
	-- Destroys the grenade tool
	if amount.Value <= 0 then
		tool:Destroy()
	end
	
	while Object.Velocity ~= 0 do
		task.wait(0.02)
		if Object.Velocity == Vector3.new(0, 0, 0) then
			break
		end
	end
	
	grenadeStats[tool.Name].grenadeFunction(Object, plr)
	
end


throw.OnServerEvent:Connect(function(plr, mousePosition, tool)
	local char = plr.Character

	local targetPos = mousePosition
	local lookAt = (targetPos - char.Head.Position).unit
	--lookAt = mousePosition.unit
	Toss(plr, lookAt, tool)
end)

