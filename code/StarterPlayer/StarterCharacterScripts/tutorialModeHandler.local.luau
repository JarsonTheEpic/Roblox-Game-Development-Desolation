repeat wait() until game.Players.LocalPlayer
task.wait(4)

local tweenService = game:GetService("TweenService")

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local tipGui = plr.PlayerGui.tipGui.tipGui
local regions = game.Workspace:WaitForChild("Regions"):WaitForChild("tutorialRegions")


local accessedRegions = {
	borderRegion = {
		region = regions.borderRegion,
		accessed = false,
		tip = "You must buy a passport and become a citizen to cross the border!"
	},
	bankRegion = {
		region = regions.bankRegion,
		accessed = false,
		tip = "To rob the bank, you must buy a C4 to explode the vault door!"
	},
	factoryRegion = {
		region = regions.factoryRegion,
		accessed = false,
		tip = "Work a shift at the factory to earn money!"
	}
}

local DEFAULT_COLOUR = Color3.fromRGB(0, 0, 0)


if script.Parent ~= game.Players.LocalPlayer.Character then
	return -- Exit the script if it's not directly under the character
end


local function createTip(Message, timeLength, textColour)

	if textColour == nil then

		textColour = DEFAULT_COLOUR
		
	end

	local tweenGuiInfo = TweenInfo.new(timeLength * 1.5, Enum.EasingStyle.Sine)
	local goal = {
		Position = tipGui.Parent.endPos.Position,
		Transparency = 1
	}

	local cloneText = tipGui:Clone()
	cloneText.Parent = tipGui.Parent

	cloneText.Position = tipGui.Position
	cloneText.Transparency = 0
	cloneText.Visible = false

	cloneText.TextColor3 = textColour
	cloneText.Text = tostring(Message)

	local tweenGui = tweenService:Create(cloneText, tweenGuiInfo, goal)

	cloneText.Visible = true

	tweenGui:Play()

	wait(timeLength)

	cloneText:Destroy()

end

-- When the player enters an area (touches it)
-- If the player is accessing this area for the first time IN THIS LIFE, then display a tip
root.Touched:Connect(function(hit)
	
	if accessedRegions[hit.Name] == nil then return end
	if accessedRegions[hit.Name].accessed == true then return end
	
	accessedRegions[hit.Name].accessed = true
	createTip(accessedRegions[hit.Name].tip, 3)
	
end)
