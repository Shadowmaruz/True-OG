

if SERVER then

	AddCSLuaFile( "shared.lua" )
	resource.AddFile("models/weapons/a_m16a2.mdl")
	resource.AddFile("models/weapons/b_m16a2.mdl")
	resource.AddFile("materials/models/weapons/v_models/m16a2/une.vmt")
	resource.AddFile("materials/models/weapons/v_models/m16a2/une.vtf")
	resource.AddFile("materials/models/weapons/v_models/m16a2/deux.vtf")
	resource.AddFile("materials/models/weapons/v_models/m16a2/deux.vmt")
	resource.AddFile("materials/models/weapons/v_models/m16a2/trois.vtf")
	resource.AddFile("materials/models/weapons/v_models/m16a2/trois.vmt")
	resource.AddFile("materials/models/weapons/v_models/m16a2/quatre.vmt")
	resource.AddFile("materials/models/weapons/v_models/m16a2/quatre.vtf")
	resource.AddFile("materials/models/weapons/w_models/w_m16.vmt")
	resource.AddFile("materials/models/weapons/w_models/w_m16.vtf")
	resource.AddFile("sound/weapons/ar_m16a2/m16a2_fire1.wav")
	resource.AddFile("sound/weapons/ar_m16a2/m16a2_fire2.wav")
	resource.AddFile("sound/weapons/ar_m16a2/m16a2_fire3.wav")
	resource.AddFile("sound/weapons/ar_m16a2/m16a2_fire4.wav")
	resource.AddFile("sound/weapons/ar_m16a2/m16a2_fire5.wav")
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "M16"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_m16"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Delay			= 0.18
SWEP.Primary.Recoil			= 1.6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Damage = 23
SWEP.Primary.Cone = 0.018
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 90
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 64
SWEP.ViewModel			= "models/weapons/a_m16a2.mdl"
SWEP.WorldModel			= "models/weapons/b_m16a2.mdl"

SWEP.Primary.Sound = Sound( "Weapon_M4A1.Single" )

SWEP.IronSightsPos = Vector(-2.643, -5.0014, 0.7141)
SWEP.IronSightsAng = Vector(0.2581, 0.0115, 2.4642)

SWEP.AltMode = 0
SWEP.AltModeText = "Firing Mode: Single"

local fire1 = Sound("weapons/ar_m16a2/m16a2_fire1.wav")
local fire2 = Sound("weapons/ar_m16a2/m16a2_fire2.wav")
local fire3 = Sound("weapons/ar_m16a2/m16a2_fire3.wav")
local fire4 = Sound("weapons/ar_m16a2/m16a2_fire4.wav")
local fire5 = Sound("weapons/ar_m16a2/m16a2_fire5.wav")

function SWEP:FireSound()
	local rand = math.random(5)
	if rand == 0 then self:EmitSound(fire1)
	elseif rand == 1 then self:EmitSound(fire2)
	elseif rand == 2 then self:EmitSound(fire3)
	elseif rand == 3 then self:EmitSound(fire4)
	else self:EmitSound(fire5)
	end
end

local function GetModeText(mode)
	if mode == 1 then ModeText = "Firing Mode: Burst"
	else ModeText = "Firing Mode: Single"
	--else  ModeText = "Firing Mode: Auto"
	end
	return ModeText
end	

function SWEP:SetZoom(state)
   if CLIENT then return end
   if not (IsValid(self.Owner) and self.Owner:IsPlayer()) then return end
   if state then
      self.Owner:SetFOV(45, 0.3)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self.AltMode == 1 then
		self:FireSound()
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, 1, self.Primary.Cone)
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
		self:TakePrimaryAmmo( 1 )
		timer.Simple(0.005, function() 
			if self:GetOwner() and self:CanPrimaryAttack() then
				self:FireSound()
				self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, 1, self.Primary.Cone)
				self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
				self:TakePrimaryAmmo( 1 )
			end
		end)
		timer.Simple(0.100, function() 
			if self:GetOwner() and self:CanPrimaryAttack() then
				self:FireSound()
				self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, 1, self.Primary.Cone)
				self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
				self:TakePrimaryAmmo( 1 )
			end
		end)
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil*3, math.Rand(-0.1,0.1) *self.Primary.Recoil*3, 0 ) )
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.54)
	else
		self:FireSound()
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, 1, self.Primary.Cone)
		self:TakePrimaryAmmo( 1 )
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
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
			--else self.AltMode = 0 self.Primary.Automatic = true end 
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
