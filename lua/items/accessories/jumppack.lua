ITEM.Name = 'Jump Pack'
ITEM.Price = 5000
ITEM.Model = 'models/xqm/jetengine.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
	ply:SetNWFloat("JetPack", 1)
	ply:SetNWFloat("JetFuel", 100)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
	ply:SetNWFloat("JetPack", 0)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.5, 0)
	pos = pos + (ang:Right() * 7) + (ang:Forward() * 6)
	
	return model, pos, ang
end

function ITEM:Think(ply, modifications)
	if ply and ply:IsValid() then
		if ply:GetNWFloat("JetPack") == 1 then
			local oldfuel = ply:GetNWFloat("JetFuel") 
			if ply:KeyDown(IN_JUMP) and oldfuel > 0 then
				timer.Simple(0.250, function()
					if ply and ply:IsValid() then
						if ply:KeyDown(IN_JUMP) and not ply:IsOnGround() and oldfuel > 0 then
							ply:EmitSound("npc/assassin/ball_zap1.wav",20,40)
							ply:SetVelocity(ply:GetUp() * 35)
							ply:SetNWFloat("JetFuel", (oldfuel-2)) 
						end
					end
				end)
			else
				if not ply:KeyDown(IN_JUMP) and ply:IsOnGround() and oldfuel < 100 then
					timer.Simple(2, function() 
						if ply and ply:IsValid() then
							if SERVER then
								oldfuel = ply:GetNWFloat("JetFuel") 
								if not ply:KeyDown(IN_JUMP) and ply:IsOnGround() and oldfuel < 100 then -- 
									ply:SetNWFloat("JetFuel", (oldfuel+0.5)) 
								end
							end
						end
					end)
				end
			end
		end
	end
end	
	
