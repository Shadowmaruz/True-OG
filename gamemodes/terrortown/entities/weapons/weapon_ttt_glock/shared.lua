
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"


if CLIENT then
   SWEP.PrintName = "Glock"
   SWEP.Slot = 1

   SWEP.Icon = "VGUI/ttt/icon_glock"
end

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_GLOCK

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 0.9
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 0.10
SWEP.Primary.Cone = 0.028
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel  = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound = Sound( "Weapon_Glock.Single" )
SWEP.IronSightsPos = Vector( -5.79, -3.9982, 2.8289 )

SWEP.HeadshotMultiplier = 1.75

SWEP.AltMode = 0
SWEP.AltModeText = "Firing Mode: Single"

local function GetModeText(mode)
	if mode == 1 then ModeText = "Firing Mode: Burst"
	else  ModeText = "Firing Mode: Single"
	end
	return ModeText
end	


-- Burst fire, and single fire
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self.AltMode == 1 then
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.35)
		if not self:CanPrimaryAttack() then return end
		self:EmitSound(self.Primary.Sound)
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.020)
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
		self:TakePrimaryAmmo( 1 )
		timer.Simple(0.005, function() 
		if self:GetOwner() and not self:CanPrimaryAttack() then return end
		self:EmitSound(self.Primary.Sound)
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.020)
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
		self:TakePrimaryAmmo( 1 )
		end)
		timer.Simple(0.105, function() 
		if self:GetOwner() and not self:CanPrimaryAttack() then return end
		self:EmitSound(self.Primary.Sound)
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.020)
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
		self:TakePrimaryAmmo( 1 )
		end)
	else
		if not self:CanPrimaryAttack() then return end
		self:EmitSound(self.Primary.Sound)
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
		self:TakePrimaryAmmo( 1 )
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.1)
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end   
	if self.Owner:KeyDown( IN_USE ) and not self.Owner:KeyDown( IN_ATTACK ) then
		self:EmitSound( "Weapon_Pistol.Empty" )
		if IsFirstTimePredicted() then
			if self.AltMode == 0 then self.AltMode = 1
			else self.AltMode = 0 end 
			self.AltModeText = GetModeText(self.AltMode)
		end
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5)
		return
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
	if not self.IronSightsPos then return end

	bIronsights = not self:GetIronsights()

	self:SetIronsights( bIronsights )
	if CLIENT then 
	   return
	else
		if(bIronsights) then self.Owner:SetFOV(self.ViewModelFOV+6, 10) return
		else self.Owner:SetFOV(0, 0) return end
	end
   self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetIronsights(false)
	if SERVER then 
		self.Owner:SetFOV(0, 0)
	end
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    if SERVER then 
		self.Owner:SetFOV(0, 0)
	end
end

function SWEP:Holster()
    self:SetIronsights(false)
    if SERVER then 
		self.Owner:SetFOV(0, 0)
	end
    return true
end