if SERVER then
    AddCSLuaFile( "shared.lua" )
	resource.AddFile("materials/models/weapons/v_models/xm8/assault_foregrip.vmt")
	resource.AddFile("materials/models/weapons/v_models/xm8/assault_foregrip.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/assault_foregrip_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/gucci.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/gucci.vmt")
	resource.AddFile("materials/models/weapons/v_models/xm8/gucci_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/main_receiver.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/main_receiver_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/main_receiver.vmt")
	resource.AddFile("materials/models/weapons/v_models/xm8/scope.vmt")
	resource.AddFile("materials/models/weapons/v_models/xm8/scope.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/scope_normal.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/stock.vmt")
	resource.AddFile("materials/models/weapons/v_models/xm8/stock.vtf")
	resource.AddFile("materials/models/weapons/v_models/xm8/stock.normal.vtf")
	resource.AddFile("materials/models/weapons/w_models/assault_foregrip.vmt")
	resource.AddFile("materials/models/weapons/w_models/stock.vmt")
	resource.AddFile("materials/models/weapons/w_models/scope.vmt")
	resource.AddFile("materials/models/weapons/w_models/main_receiver.vmt")
	resource.AddFile("models/weapons/w_rif_xm8_hum.mdl")
	resource.AddFile("models/weapons/v_rif_xm8_hum.mdl")
	resource.AddFile("sound/weapons/xm8/xm8_shoot.wav")
	resource.AddFile("materials/vgui/ttt/xm8_humility.vtf")
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName			= "Heckler & Koch XM8"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/xm8_humility"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Delay			= 0.23
SWEP.Primary.Recoil			= 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 27
SWEP.Primary.Cone = 0.018
SWEP.Primary.ClipSize = 25
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 25
SWEP.HeadshotMultiplier = 3
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 64
SWEP.ViewModel			= "models/weapons/v_rif_xm8_hum.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_xm8_hum.mdl"

SWEP.Primary.Sound = Sound( "weapons/XM8/xm8_shoot.wav" )
SWEP.Secondary.Sound	 = Sound("Default.Zoom")

SWEP.IronSightsPos = Vector(2.13, 0, -10)
SWEP.IronSightsAng = Vector(2.599, -1.3, -1.6)

if CLIENT then
   SWEP.Icon = "VGUI/ttt/xm8_humility"
end

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(30, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
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
	if self:GetIronsights() then
		self:SetZoom(false)
		self:SetIronsights(false)
	end
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if self:GetIronsights() then
		self:SetZoom(false)
		self:SetIronsights(false)
	end
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
end


function SWEP:Holster()
	if self:GetIronsights() then
		self:SetZoom(false)
		self:SetIronsights(false)
	end
    return true
end

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

      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end