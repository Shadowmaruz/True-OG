ITEM.Name = 'Backpack'
ITEM.Price = 100
ITEM.Model = 'models/props_c17/SuitCase_Passenger_Physics.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
	ply:SetNWFloat("BackPack", 1)
	ply:SetNWFloat("ExtraWeapon", 0)
end

function ITEM:OnHolster(ply)
	if ply and ply:IsValid() then
		ply:PS_RemoveClientsideModel(self.ID)
		ply:SetNWFloat("BackPack", 0)
		for _, w in pairs(ply:GetWeapons()) do
			if w.Kind and w.Kind == 3 then
				if ply:GetNWFloat("ExtraWeapon") == 1 then
					if SERVER then
						ply:DropWeapon(w)
					end
					ply:SetNWFloat("ExtraWeapon", 0) 
					return
				end
			end
		end
	end
end	

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.8, 0)
	pos = pos + (ang:Right() * 5) + (ang:Up() * 6) + (ang:Forward() * 2)
	
	return model, pos, ang
end
function ITEM:Think(ply, modifications)
	if ply and ply:IsValid() and ply:GetNWFloat("BackPack") == 1 then
		local numz = 0
		for _, w in pairs(ply:GetWeapons()) do
			if w.Kind and w.Kind == 3 then
				numz = numz+1
				if numz > 2 then
					if SERVER then
						ply:DropWeapon(w)
					end				
				end
			end
		end
		if numz > 1 then
			ply:SetNWFloat("ExtraWeapon", 1)
		end
	end	
end	