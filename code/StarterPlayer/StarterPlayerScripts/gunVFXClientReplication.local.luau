local clientRemote = game:WaitForChild("ReplicatedStorage").gameplayEvents.gunRemotes.clientGunHandler

local gunVFX = game:WaitForChild("ReplicatedStorage").gunVFX.gunVFX

clientRemote.OnClientEvent:Connect(function(plr, gun)
	local VFX = gunVFX.VFX:Clone()
	--local fireSound = gunVFX.Fire:Clone()
	--fireSound.Parent = gun.Handle
	--fireSound:Play()
	VFX.Parent = gun.Handle.Barrel
	
	spawn(function()
		for i, v in VFX:GetChildren() do
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end)
	
	game.Debris:AddItem(VFX, 3)
	--game.Debris:AddItem(fireSound, 3)

end)