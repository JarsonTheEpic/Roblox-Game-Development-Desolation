local hitmarkEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.gunRemotes.gunHitmarker
local hitmarker = game:WaitForChild("ReplicatedStorage").gameplayEvents.gunRemotes.hitmarker
local tweenService = game:GetService("TweenService")
repeat task.wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local hitmarkSound = script.hitmarkSound

hitmarkEvent.OnClientEvent:Connect(function(damageNumber, hitPart, hitColour)
	
	local hitmark = hitmarkSound:Clone()
	hitmark.Parent = plr.Character.HumanoidRootPart
	hitmark:Destroy()
	
	local billboard = hitmarker:Clone()
	billboard.StudsOffset = Vector3.new(math.random(-60, 60) * 0.1, math.random(60, 100) * 0.1, math.random(-120, 120) * 0.1)
	billboard.Parent = hitPart
	
	local damageText = billboard.TextLabel
	damageText.Text = damageNumber
	
	if hitColour == "red" then
		damageText.TextColor3 = Color3.fromRGB(255, 0, 50)
	elseif hitColour == "orange" then
		damageText.TextColor3 = Color3.fromRGB(235, 125, 0)
	elseif hitColour == "yellow" then
		damageText.TextColor3 = Color3.fromRGB(255, 235, 0)
	end
	
	--damageText.Font = Enum.Font.Bangers
	--damageText.TextSize = 35
	--damageText.BackgroundTransparency = 1
	damageText.Parent = billboard
	
	local info = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	local properties = {StudsOffset = billboard.StudsOffset + Vector3.new(0, 3, 0)}
	local tween = tweenService:Create(billboard, info, properties)
	tween:Play()
	
	task.wait(0.5)
	
	info = TweenInfo.new(0.7, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
	properties = {StudsOffset = billboard.StudsOffset - Vector3.new(0, 6, 0)}
	tween = tweenService:Create(billboard, info, properties)
	tween:Play()
	
	task.wait(0.7)
	
	game.Debris:AddItem(billboard, 0.15)
	
end)