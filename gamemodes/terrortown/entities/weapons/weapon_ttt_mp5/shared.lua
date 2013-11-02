resource.AddFile("materials/vgui/ttt/icon_mp5.vmt")

-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
   SWEP.PrintName = "MP5"
   SWEP.Slot      = 2 -- add 1 to get the slot number key

   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   
   SWEP.Icon = "VGUI/ttt/icon_mp5"
end

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"

--- Standard GMod values

SWEP.HoldType			= "ar2"

SWEP.Primary.Delay       = 0.078
SWEP.Primary.Recoil      = 1.2
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 19
SWEP.Primary.Cone        = 0.02
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Sound       = Sound( "Weapon_MP5Navy.Single" )

SWEP.IronSightsPos = Vector(4.84, 0.36, 1.84)
SWEP.IronSightsAng = Vector(1.1, 0.3, 0)

SWEP.ViewModel  = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"


-- TTT --
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.CanBuy = false
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false

function SWEP:PrimaryAttack(worldsnd)

   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
	if SERVER then
		if(self:GetIronsights()) then self.Owner:SetFOV(0, 0.1) timer.Simple(2, function() if(self:GetIronsights()) then self.Owner:SetFOV(60, 10) end end) end
	end

   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end

function SWEP:SecondaryAttack()
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end   
	bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
	if SERVER then
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