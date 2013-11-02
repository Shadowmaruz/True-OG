ITEM.Name = 'Colt M4A1'
ITEM.Price = 40
ITEM.Model = 'models/weapons/b_m4.mdl'
ITEM.WeaponClass = "weapon_ttt_m4a1"
ITEM.SingleUse = true
ITEM.Karma = 100

--WEAPON_NONE   = 0
--WEAPON_MELEE  = 1
--WEAPON_PISTOL = 2
--WEAPON_HEAVY  = 3
--WEAPON_NADE   = 4
--WEAPON_CARRY  = 5
--WEAPON_EQUIP1 = 6
--WEAPON_EQUIP2 = 7
--WEAPON_ROLE   = 8

function ITEM:OnBuy(ply)
	if not ply:CanCarryType(3) and not ply:HasWeapon(self.WeaponClass) then
		for _, w in pairs(ply:GetWeapons()) do
			if w.Kind and w.Kind == 3 then
				ply:DropWeapon(w)
			end
		end
	end
	if not ply:HasWeapon(self.WeaponClass) then
		ply:Give(self.WeaponClass)
	end
	ply:GiveAmmo(40,ply:GetWeapon(self.WeaponClass).Primary.Ammo )
	ply:SelectWeapon(ply:GetWeapon(self.WeaponClass))
end