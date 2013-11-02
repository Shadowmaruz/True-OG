	if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"

if CLIENT then

   SWEP.PrintName = "MAC10"
   SWEP.Slot = 2

   SWEP.Icon = "VGUI/ttt/icon_mac"
end


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_MAC10

SWEP.Primary.Damage      = 9
SWEP.Primary.Delay       = 0.045
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 40
SWEP.Primary.ClipMax     = 120
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.15
SWEP.Primary.Sound       = Sound( "Weapon_mac10.Single" )

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel  = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.IronSightsPos = Vector(-8.921, -9.528, 2.9)
SWEP.IronSightsAng = Vector(0.699, -5.301, -7)

SWEP.DeploySpeed = 3

SWEP.AltMode = 0
SWEP.AltModeText = "Firing Mode: Auto"

local function GetModeText(mode)
	if mode == 1 then ModeText = "Firing Mode: Burst"
	else  ModeText = "Firing Mode: Auto"
	end
	return ModeText
end	


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if IsFirstTimePredicted() then
		if self.AltMode == 1 then
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.070)
			if not self:CanPrimaryAttack() then return end
			self:EmitSound(self.Primary.Sound)
			self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.025)
			self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
			self:TakePrimaryAmmo( 1 )
			timer.Simple(0.0025, function() 
			if not self:CanPrimaryAttack() then return end
			self:EmitSound(self.Primary.Sound)
			self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.025)
			self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
			self:TakePrimaryAmmo( 1 )
			end)
			timer.Simple(0.105, function() 
			if not self:CanPrimaryAttack() then return end
			self:EmitSound(self.Primary.Sound)
			self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, 0.025)
			self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
			self:TakePrimaryAmmo( 1 )
			end)
		else
			if IsFirstTimePredicted() then
				if not self:CanPrimaryAttack() then return end
				self:EmitSound(self.Primary.Sound)
				self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
				self:TakePrimaryAmmo( 1 )
				self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.045)
			end
		end
	end
	if SERVER then 
		if(self:GetIronsights()) then self.Owner:SetFOV(0, 0.1) timer.Simple(2, function() self.Owner:SetFOV(60, 10) end) end
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
end


function SWEP:SecondaryAttack()
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end   
	if self.Owner:KeyDown( IN_USE ) and not self.Owner:KeyDown( IN_ATTACK ) then
		self:EmitSound( "Weapon_Pistol.Empty" )
		if IsFirstTimePredicted() then
			if self.AltMode == 0 then self.AltMode = 1 self.Primary.Automatic = false
			else self.AltMode = 0 self.Primary.Automatic = true end 
			self.AltModeText = GetModeText(self.AltMode)
		end
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5)
		return
	end
	if not self.IronSightsPos then return end

	bIronsights = not self:GetIronsights()

	self:SetIronsights( bIronsights )
	if CLIENT then 
	   return
	else
		if(bIronsights) then self.Owner:SetFOV(self.ViewModelFOV+6, 10) return
		else self.Owner:SetFOV(0, 0) return end
	end
	
	--if SERVER then
	--   self:SetZoom(bIronsights)
	--end
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 2 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 150)

   -- decay from 3.2 to 1.7
   return 1.7 + math.max(0, (1.5 - 0.002 * (d ^ 1.25)))
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