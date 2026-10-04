local rs = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local cs = game:GetService("CollectionService")

local OFFSET = 6 -- studs in front of player
local ANGULAR_OFFSET = CFrame.Angles(math.rad(90), math.rad(0), math.rad(-90)) -- Apply this offset to get the rotation of the arrow correct

local waypointEvent = rs.gameplayEvents.createWaypoint
local waypointArrow = rs.waypointArrow

local arrow
local pos

repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local hrp = char:WaitForChild("HumanoidRootPart")


waypointEvent.OnClientEvent:Connect(function(create, position) -- Creates the arrow
	
	arrow = game.Workspace:FindFirstChild("waypointArrow") -- Looks for an arrow and deletes it
	if arrow then
		arrow:Destroy()
	end
	
	if create == false then return end
	
	arrow = waypointArrow:Clone()
	arrow.Parent = workspace
	
	pos = position
	
end)


run.RenderStepped:Connect(function()
	
	if arrow and pos then		

		local forward = (pos - hrp.Position).Unit
		local arrowPos = hrp.Position + forward * OFFSET

		arrow.CFrame = CFrame.lookAt(arrowPos, pos)
		arrow.CFrame = arrow.CFrame * ANGULAR_OFFSET
		
	end
	
end)
