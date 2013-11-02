ITEM.Name = 'Handheld Rifle'
ITEM.Price = 30
ITEM.Model = 'models/weapons/w_snip_g2_hum.mdl'
ITEM.WeaponClass = 'weapon_ttt_g2'
ITEM.SingleUse = true
ITEM.Karma = 100

function ITEM:OnBuy(ply)
	local AlreadyHave = false
	for _, w in pairs(ply:GetWeapons()) do
		if not ply:CanCarryType(3) then
			if w.Kind and w.Kind == 3 then
				if w == self.WeaponClass then
					AlreadyHave = true
				else
					ply:DropWeapon(w)
				end
				
			end
		end
		if not AlreadyHave then
			ply:Give(self.WeaponClass)
		end
		ply:GiveAmmo(30,self.WeaponClass.Primary.Ammo)
		ply:SelectWeapon(self.WeaponClass)
	end
end