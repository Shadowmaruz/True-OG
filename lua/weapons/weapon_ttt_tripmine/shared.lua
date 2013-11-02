    if SERVER then
       AddCSLuaFile( "shared.lua" )
       resource.AddFile("materials/vgui/ttt/icon_tripwire.png")
    else
	hook.Add("PostDrawOpaqueRenderables","TTT_TripmineViewer",function()
		if LocalPlayer():GetRole() == ROLE_TRAITOR then
			local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*10
			local ang = LocalPlayer():EyeAngles()
			ang = Angle(ang.p+90,ang.y,0)
			for k, v in pairs(ents.FindByClass("npc_tripmine")) do
				render.ClearStencil()
				render.SetStencilEnable(true)
					render.SetStencilWriteMask(255)
					render.SetStencilTestMask(255)
					render.SetStencilReferenceValue(15)
					render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
					render.SetBlend(0)
					v:DrawModel()
					render.SetBlend(1)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
					cam.Start3D2D(pos,ang,1)
							surface.SetDrawColor(255,0,0,255)
							surface.DrawRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
					cam.End3D2D()
					v:DrawModel()
				render.SetStencilEnable(false)
			end
		end
	end)
end

    SWEP.HoldType                           = "slam"
     
    if CLIENT then
     
       SWEP.PrintName    = "Tripwire Mine"
       SWEP.Slot         = 6
     
       SWEP.ViewModelFlip = true
       SWEP.ViewModelFOV                    = 64
       
       SWEP.EquipMenuData = {
          type = "item_weapon",
          desc = [[A mine, with a red laster, placeable on walls. 
		  When the red laser is crossed by innocents or 
		  detectives, the mine explodes. 
		  
		  Fixed for True-OG by Shadow
		  Added Seconddary to pick up your mine!]]
       };
     
       SWEP.Icon = "vgui/ttt/icon_tripwire.png"
    end
	SWEP.Base = "weapon_tttbase"
	 
    SWEP.ViewModel                          = "models/weapons/v_slam.mdl"   -- Weapon view model
    SWEP.WorldModel                         = "models/weapons/w_slam.mdl"   -- Weapon world model
    SWEP.FiresUnderwater = false
     
    SWEP.Primary.Sound                      = Sound("")             -- Script that calls the primary fire sound
    SWEP.Primary.Delay                      = .5                    -- This is in Rounds Per Minute
    SWEP.Primary.ClipSize                   = 3             -- Size of a clip
    SWEP.Primary.DefaultClip                = 3             -- Bullets you start with
    SWEP.Primary.Automatic                  = false         -- Automatic = true; Semi Auto = false
    SWEP.Primary.Ammo                       = "slam"
	SWEP.LimitedStock = true
	
	SWEP.NoSights = true
     
    SWEP.AllowDrop = false
    SWEP.Kind = WEAPON_EQUIP
    SWEP.CanBuy = {ROLE_TRAITOR}
     
    function SWEP:Deploy()
            self:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
            return true
    end
     
    function SWEP:SecondaryAttack()
			self:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
            return false
    end    
     
    function SWEP:OnRemove()
       if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
          RunConsoleCommand("lastinv")
       end
    end
     
function SWEP:PrimaryAttack()
	self:TripMineStick()
	self.Weapon:EmitSound( Sound( "Weapon_SLAM.SatchelThrow" ) )
	self.Weapon:SetNextPrimaryFire(CurTime()+(self.Primary.Delay))
end
function SWEP:SecondaryAttack()
-- Added by Shadow
if SERVER then
	local ignore = {ply, self.Weapon}
    local spos = ply:GetShootPos()
    local epos = spos + ply:GetAimVector() * 80
    local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})
	  
	--if tr.HitNonWorld then
		local tmine = tr.Entity()
		if IsValid(tmine) then
			Msg(" Yay 1 ")
			if tmine.IsNPC() then
				Msg(" Yay 2 ")
				if ( tmine.ent:GetModel() == "models/weapons/w_slam" ) then
					Msg(" Yay 3 ")
					if tmine.fingerprints == self.fingerprint then
						Msg(" Yay 4 ")
						if self.Owner == nil then return end
						Msg( " Yay 5 " )
						self.Owner:GiveAmmo(1,"slam")
						tmine:Remove()
						end
					end
				end
			end
		end	 
	--end	 
end     
function SWEP:TripMineStick()
 if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end
 
 
      local ignore = {ply, self.Weapon}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})
 
      if tr.HitWorld then
         local mine = ents.Create("npc_tripmine")
         if IsValid(mine) then
 
            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, mine)
 
            if tr_ent.HitWorld then
 
               local ang = tr_ent.HitNormal:Angle()
               ang.p = ang.p + 90
 
               mine:SetPos(tr_ent.HitPos + (tr_ent.HitNormal * 3))
               mine:SetAngles(ang)
               mine:SetOwner(ply)
               mine:Spawn()
 
                                mine.fingerprints = self.fingerprints
								
                                self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH )
                               
                                local holdup = self.Owner:GetViewModel():SequenceDuration()
                               
                                timer.Simple(holdup,
								function()
								if SERVER then
                                    self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH2 )
								end   
                                end)
                                       
                                timer.Simple(holdup + .1,
								function()
                                        if SERVER then
                                                if self.Owner == nil then return end
                                                if self.Weapon:Clip1() == 0 && self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
                                                --self.Owner:StripWeapon(self.Gun)
                                                --RunConsoleCommand("lastinv")
												self:Remove()   -- Shadow: Removed for picking them back up
                                                else
                                                self:Deploy()
                                                end
                                        end
                                end)
                       

                               --self:Remove()
                                self.Planted = true
								
							self:TakePrimaryAmmo( 1 )
                               
                        end
					end
			end
      end
end

function SWEP:Reload()
   return false
end