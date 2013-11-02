
if SERVER then
   AddCSLuaFile( "shared.lua" )
   
end

SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName	 = "Flashbang"
   SWEP.Slot		 = 3

   SWEP.Icon = "VGUI/ttt/icon_nades"
end

SWEP.EquipMenuData = {
      type="Weapon",
      model="models/weapons/w_eq_flashbang.mdl",
      name="Flashbang Grenade",
      desc="Just like its sounds. Flash and Bang /n Made by Shadow"
   };

SWEP.Base				= "weapon_tttbasegrenade"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.WeaponID = AMMO_SMOKE
SWEP.Kind = WEAPON_NADE

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight			= 5
SWEP.AutoSpawnable      = false
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_flashgrenade_proj"
end


