local Object = script.Parent
local Used = false

local SplashDamage = 50
local Radius = 10
local GrenadeArmorFactor = 1

local Tag = Object:WaitForChild("creator")
local Debris = game:GetService("Debris")


function OnExplosionHit(Character, hitDistance, blastCenter)
	local Humanoid = Character:FindFirstChild("Humanoid")
	if hitDistance and blastCenter then
		local DistanceFactor = hitDistance/Radius
		DistanceFactor = 1-DistanceFactor
		if Humanoid then
			if Humanoid.Health > 0 then
				if  Humanoid.Parent:FindFirstChild("Saude")~= nil then
					if  Humanoid.Parent.Saude.Protecao.HelmetVida.Value > 0 and Humanoid.Parent.Saude.Protecao.VestVida.Value > 0 then

						if GrenadeArmorFactor <= (Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value + Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value) then
							
							local VestMult = ((100 - GrenadeArmorFactor)/(Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value))
							local HelmMult = ((100 - GrenadeArmorFactor)/(Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value))
							
							if VestMult > 1 then
								VestMult = 1
							elseif VestMult < 0 then
								VestMult = 0
							end

							if HelmMult > 1 then
								HelmMult = 1
							elseif HelmMult < 0 then
								HelmMult = 0
							end

							local HitDamage = (DistanceFactor*SplashDamage) * (GrenadeArmorFactor/(Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value + Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value))
							local VestDamage = ((DistanceFactor*SplashDamage) * VestMult)
							local HelmDamage = ((DistanceFactor*SplashDamage) * HelmMult)
							print("Colete + Helm: " ..HitDamage)
							if VestDamage <= 0 then
								VestDamage = 1
							end
							if HelmDamage <= 0 then
								HelmDamage = 1
							end
							if HitDamage <= 0 then
								HitDamage = 1
							end
							Humanoid.Parent.Saude.Protecao.HelmetVida.Value = Humanoid.Parent.Saude.Protecao.HelmetVida.Value - HelmDamage
							Humanoid.Parent.Saude.Protecao.VestVida.Value = Humanoid.Parent.Saude.Protecao.VestVida.Value - VestDamage
							Humanoid:TakeDamage(HitDamage)
						else
							local HitDamage = DistanceFactor*SplashDamage
							print(HitDamage)
							Humanoid:TakeDamage(HitDamage)
						end

					elseif Humanoid.Parent.Saude.Protecao.HelmetVida.Value > 0 and Humanoid.Parent.Saude.Protecao.VestVida.Value <= 0 then
						if GrenadeArmorFactor <= (Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value) then
					
							local HelmMult = ((100 - GrenadeArmorFactor)/(Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value))						
							
							if HelmMult > 1 then
								HelmMult = 1
							elseif HelmMult < 0 then
								HelmMult = 0
							end

							local HitDamage = (DistanceFactor*SplashDamage) * (GrenadeArmorFactor/(Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value + Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value))
							local HelmDamage = ((DistanceFactor*SplashDamage) * HelmMult)
							
							print("Helm: " ..HitDamage)

							if HelmDamage <= 0 then
								HelmDamage = 1
							end
							if HitDamage <= 0 then
								HitDamage = 1
							end

							Humanoid.Parent.Saude.Protecao.HelmetVida.Value = Humanoid.Parent.Saude.Protecao.HelmetVida.Value - HelmDamage
							Humanoid:TakeDamage(HitDamage)
						else
							local HitDamage = DistanceFactor*SplashDamage
							print(HitDamage)
							Humanoid:TakeDamage(HitDamage)
						end

					elseif Humanoid.Parent.Saude.Protecao.HelmetVida.Value <= 0 and Humanoid.Parent.Saude.Protecao.VestVida.Value > 0 then
						if GrenadeArmorFactor <= (Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value) then
							
							local VestMult = ((100 - GrenadeArmorFactor)/(Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value))
							
							if VestMult > 1 then
								VestMult = 1
							elseif VestMult < 0 then
								VestMult = 0
							end


							local HitDamage = (DistanceFactor*SplashDamage) * (GrenadeArmorFactor/(Humanoid.Parent.Saude.Protecao.VestBlastProtect.Value + Humanoid.Parent.Saude.Protecao.HelmetBlastProtect.Value))
							local VestDamage = ((DistanceFactor*SplashDamage) * VestMult)

							print("Colete: " ..HitDamage)
							if VestDamage <= 0 then
								VestDamage = 1
							end
							if HitDamage <= 0 then
								HitDamage = 1
							end
							Humanoid.Parent.Saude.Protecao.VestVida.Value = Humanoid.Parent.Saude.Protecao.VestVida.Value - VestDamage
							Humanoid:TakeDamage(HitDamage)
						else
							local HitDamage = DistanceFactor*SplashDamage
							print(HitDamage)
							Humanoid:TakeDamage(HitDamage)
						end

					elseif Humanoid.Parent.Saude.Protecao.HelmetVida.Value <= 0 and Humanoid.Parent.Saude.Protecao.VestVida.Value <= 0 then
						local HitDamage = DistanceFactor*SplashDamage
						print(HitDamage)
						Humanoid:TakeDamage(HitDamage)
					end
				else
					local HitDamage = DistanceFactor*SplashDamage
					print(HitDamage)
					Humanoid:TakeDamage(HitDamage)
				end
			end
		end
	end
end

function Explode()
	wait(2)
	Object.Fuse:Play()
	Object.Smoke1.Enabled = true
	Object.Smoke2.Enabled = true
	Object.Smoke3.Enabled = true
	wait(60)
	Object.Fuse:Stop()
	Object.Smoke1.Enabled = false
	Object.Smoke2.Enabled = false
	Object.Smoke3.Enabled = false
	wait(5)
	Object:Destroy()
	Object:Destroy()
end

--helpfully checks a table for a specific value
function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end

--used by checkTeams

function tagHuman(human)
	local tag = Tag:Clone()
	tag.Parent = human
	game:GetService("Debris"):AddItem(tag)
end

--use this to determine if you want this human to be harmed or not, returns boolean

function boom()
	wait(1)
	Used = true
	Object.Anchored = false
	--Object.Orientation = Vector3.new(0,0,0)
	Object.Transparency = 1
	Explode()
end

boom()