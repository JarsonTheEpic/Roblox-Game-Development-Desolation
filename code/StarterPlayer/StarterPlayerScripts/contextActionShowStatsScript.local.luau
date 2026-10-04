local contextActionService = game:GetService("ContextActionService")

repeat wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer

local function onEPress(actionName, inputState, inputObj) -- When E button is pressed, open player info page
	
	if inputState == Enum.UserInputState.Begin and plr.inLobby.Value == false then
		
		plr.PlayerGui.playerInfo.infoFrame.Visible = not plr.PlayerGui.playerInfo.infoFrame.Visible
		
	end
	
end

contextActionService:BindAction("openPlayerInfo", onEPress, false, Enum.KeyCode.B)

