repeat wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer

game:GetService("UserInputService").MouseIconEnabled = false
local image = Instance.new("ImageLabel",plr.PlayerGui.ScreenGui)
image.Image = "http://www.roblox.com/asset/?id=9947945465"
image.AnchorPoint = Vector2.new(.5,.5)
image.Position = UDim2.fromScale(.5,.5)