
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType           = "ar2"

if CLIENT then
   SWEP.PrintName          = "rifle_name"

   SWEP.Slot               = 2

   SWEP.Icon = "VGUI/ttt/icon_scout"
end


SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_RIFLE

SWEP.Primary.Delay          = 1.5
SWEP.Primary.Recoil         = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.Damage = 50
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 10
SWEP.Primary.ClipMax = 20 -- keep mirrored to ammo
SWEP.Primary.DefaultClip = 10

SWEP.HeadshotMultiplier = 4

SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_357_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel          = Model("models/weapons/cstrike/c_snip_scout.mdl")
SWEP.WorldModel         = Model("models/weapons/w_snip_scout.mdl")

SWEP.Primary.Sound = Sound(")weapons/scout/scout_fire-1.wav")

SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )

SWEP.AltMode = 0
SWEP.AltModeText = "Scope: 10X"

local function GetModeText(mode)
	if mode == 0 then ModeText = "Scope: 10X"
	elseif mode == 1 then ModeText = "Scope: 4X"
	elseif mode == 2 then ModeText = "Scope: 2X"
	else  ModeText = "Scope: 4X"
	end
	return ModeText
end	

function SWEP:SetZoom(state)
    if CLIENT or not self then 
		return
    elseif self.Owner and IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
		  if (self.AltMode == 0) then self.Owner:SetFOV(10, 0.3)
		  elseif(self.AltMode == 1) then self.Owner:SetFOV(20, 0.3)
		  elseif(self.AltMode == 2) then self.Owner:SetFOV(30, 0.3)
		  else self.Owner:SetFOV(20, 0.3) end
       else
          self.Owner:SetFOV(0, 0.2) 
       end
    end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:EmitSound(self.Primary.Sound)
	local conez
	if self.AltMode == 0 then conez = 0.002
	elseif self.AltMode == 1 then conez = 0.003
	else conez = 0.003 end
	--if not self:GetIronsights() then conez = 0.5 end
	self:ShootBullet( self.Primary.Damage,self.Primary.Recoil,1, conez )
	self:TakePrimaryAmmo( 1 )
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1)
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.5)
	timer.Simple(0.1, function() if self:GetOwner() then self:SetZoom(false) self:SetIronsights(false)end end)
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
	if not self then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end   
	if self.Owner:KeyDown( IN_USE ) and not self.Owner:KeyDown( IN_ATTACK ) and self.Weapon:GetNextSecondaryFire() < (CurTime()+0.3) then --and self:GetIronsights() then
		self:EmitSound( "Weapon_Pistol.Empty" )
		if IsFirstTimePredicted() then
			if self.AltMode == 0 then self.AltMode = 1
			elseif self.AltMode == 1 then self.AltMode = 2
			elseif self.AltMode == 2 then self.AltMode = 3
			else self.AltMode = 0 end
			self.AltModeText = GetModeText(self.AltMode)
			if CLIENT then self.Owner:PrintMessage( HUD_PRINTTALK, self.AltModeText ) end
		end
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5)
		if SERVER then
			self:SetZoom(bIronsights)
		else
			self:EmitSound(self.Secondary.Sound)
		end
		return
	end
	if not self.IronSightsPos then return end
	bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
	if self then 
		self:SetZoom(false)
		self:SetIronsights(false)
	end
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if self then 
		self.Weapon:DefaultReload( ACT_VM_RELOAD );
		self:SetZoom(false)
		self:SetIronsights(false)
	end
end


function SWEP:Holster()
	if self then 
		self:SetZoom(false)
		self:SetIronsights(false)
	end
    return true
end

local ModeFPS = 999

if CLIENT then
	local scope = surface.GetTextureID("sprites/scope")
	function SWEP:DrawHUD()
		if self:GetIronsights() then
			surface.SetDrawColor( 0, 0, 0, 255 )
         
			local x = ScrW() / 2.0
			local y = ScrH() / 2.0
			local scope_size = ScrH()

			-- crosshair
			local gap = 80
			local length = scope_size
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )

			gap = 0
			length = 50
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )


			-- cover edges
			local sh = scope_size / 2
			local w = (x - sh) + 2
			surface.DrawRect(0, 0, w, scope_size)
			surface.DrawRect(x + sh - 2, 0, w, scope_size)

			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine(x, y, x + 1, y + 1)

			-- scope
			surface.SetTexture(scope)
			surface.SetDrawColor(255, 255, 255, 255)

			surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
			--self:DrawAltMode(GetModeText(self.AltMode))
		else
			return self.BaseClass.DrawHUD(self)
		end
	end	
	function SWEP:AdjustMouseSensitivity()
		if self.AltMode == 0 then
			return (self:GetIronsights() and 0.1) or nil
		elseif self.AltMode == 1 then
			return (self:GetIronsights() and 0.2) or nil
		else 
			return (self:GetIronsights() and 0.4) or nil
		end
	end
end

