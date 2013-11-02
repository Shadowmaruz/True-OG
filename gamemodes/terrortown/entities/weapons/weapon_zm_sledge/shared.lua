if SERVER then
	AddCSLuaFile( "shared.lua" )
	resource.AddFile("models/weapons/a_m249.mdl")
	resource.AddFile("models/weapons/b_m249.mdl")
	resource.AddFile("materials/models/weapons/v_models/m249/belt.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/belt.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/bolt.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/bolt.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/boxmag.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/boxmag.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/front.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/front.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/fullstock.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/fullstock.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/heatshield.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/heatshield.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/receiver.vtf")	
	resource.AddFile("materials/models/weapons/v_models/m249/receiver.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/receiveraddons.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/receiveraddons.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/sights.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/sights.vmt")
	resource.AddFile("materials/models/weapons/v_models/m249/topthing.vtf")
	resource.AddFile("materials/models/weapons/v_models/m249/upper.vmt")
	resource.AddFile("materials/models/weapons/w_models/w_m249.vmt")
	resource.AddFile("materials/models/weapons/w_models/w_m249.vtf")
	resource.AddFile("materials/weapons/weapon_fas_m249.vtf")	
	resource.AddFile("materials/weapons/weapon_fas_m249.vmt")		
	resource.AddFile("sound/weapons/mg_m249/m249_fire1.wav")
	resource.AddFile("sound/weapons/mg_m249/m249_fire2.wav")
	resource.AddFile("sound/weapons/mg_m249/m249_fire3.wav")
	resource.AddFile("sound/weapons/mg_m249/m249_fire4.wav")
	resource.AddFile("sound/weapons/mg_m249/m249_fire5.wav")
	resource.AddFile("materials/models/shells/m249links.vmt")
	resource.AddFile("materials/models/shells/m249links.vtf")
	
end

SWEP.HoldType			= "crossbow"


if CLIENT then

   SWEP.PrintName			= "H.U.G.E-249"

   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_m249"

   SWEP.ViewModelFlip		= false
end


SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M249


SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 0.055
SWEP.Primary.Cone = 0.063
SWEP.Primary.ClipSize = 150
SWEP.Primary.ClipMax = 150
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AirboatGun"
SWEP.AutoSpawnable      = true
SWEP.Primary.Recoil			= 1.9
SWEP.Primary.Sound			= Sound("Weapon_m249.Single")

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/a_m249.mdl"
SWEP.WorldModel			= "models/weapons/b_m249.mdl"

SWEP.HeadshotMultiplier = 2.7

SWEP.IronSightsPos = Vector(-4.0153, -5.0006, 2.0053)
SWEP.IronSightsAng = Vector(0.1243, -0.0297, 0)

local fire1 = Sound("weapons/mg_m249/m249_fire1.wav")
local fire2 = Sound("weapons/mg_m249/m249_fire2.wav")
local fire3 = Sound("weapons/mg_m249/m249_fire3.wav")
local fire4 = Sound("weapons/mg_m249/m249_fire4.wav")
local fire5 = Sound("weapons/mg_m249/m249_fire5.wav")

function SWEP:FireSound()
	local rand = math.random(5)
	if rand == 0 then self:EmitSound(fire1)
	elseif rand == 1 then self:EmitSound(fire2)
	elseif rand == 2 then self:EmitSound(fire3)
	elseif rand == 3 then self:EmitSound(fire4)
	else self:EmitSound(fire5)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:FireSound()
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, 1, self.Primary.Cone)
	self:TakePrimaryAmmo( 1 )
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	if SERVER then 
		if(self:GetIronsights()) then self.Owner:SetFOV(0, 0.1) timer.Simple(2, function() self.Owner:SetFOV(60, 10) end) end
	end
end

function SWEP:SecondaryAttack()
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end   
	bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
	if CLIENT then 
       return
    else
		if(bIronsights) then self.Owner:SetFOV(self.ViewModelFOV+6, 10) return
		else self.Owner:SetFOV(0, 0) return
		end
	end
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
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