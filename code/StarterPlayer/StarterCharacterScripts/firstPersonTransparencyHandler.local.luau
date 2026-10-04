local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local RENDER_PRIORITY = Enum.RenderPriority.Character.Value - 5

local visibleParts = {
	"RightHand",
	"RightLowerArm",
	"RightUpperArm",
	"LeftHand",
	"LeftLowerArm",
	"LeftUpperArm",
	"RightFoot",
	"RightLowerLeg",
	"RightUpperLeg",
	"LeftFoot",
	"LeftLowerLeg",
	"LeftUpperLeg"
}

local function updateCharacterTransparency()
	local character = LocalPlayer.Character

	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				
				for i, visible in pairs (visibleParts) do
					if part.Name == visible then
						part.LocalTransparencyModifier = 0
					end
				end
				
			end
		end
	end
end

RunService:BindToRenderStep("CharacterTransparency", RENDER_PRIORITY, updateCharacterTransparency)
