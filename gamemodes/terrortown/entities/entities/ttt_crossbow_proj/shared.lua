-- Crossbow Bolt fixed!

if SERVER then
   AddCSLuaFile("shared.lua")
else
   ENT.PrintName = "Crossbow Bolt"
   ENT.Icon = "VGUI/ttt/icon_crossbow"
end


ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_knife_t.mdl")

-- When true, score code considers us a weapon
ENT.Projectile = true

ENT.Stuck = false
ENT.Weaponised = false
ENT.CanHavePrints = false
ENT.IsSilent = true
ENT.CanPickup = false

ENT.WeaponID = AMMO_CROSSBOW

ENT.Damage = 150

function ENT:Initialize()
   self.Entity:SetModel(self.Model)

   self.Entity:PhysicsInit(SOLID_VPHYSICS)

   if SERVER then
      self:SetGravity(0.0)
      self:SetFriction(0.0)
      self:SetElasticity(0.45)

      self.StartPos = self:GetPos()

      self.Entity:NextThink(CurTime())
   end
   self.Stuck = false
end

function ENT:HitPlayer(other, tr)

   local range_dmg = math.max(self.Damage, self.StartPos:Distance(self:GetPos()) / 3)

--   if other:Health() < range_dmg + 10 then
--      self:KillPlayer(other, tr)
   if SERVER then
      local dmg = DamageInfo()
      dmg:SetDamage(range_dmg)
      dmg:SetAttacker(self:GetOwner())
      dmg:SetInflictor(self.Entity)
      dmg:SetDamageForce(self:EyeAngles():Forward())
      dmg:SetDamagePosition(self:GetPos())
      dmg:SetDamageType(DMG_SLASH)

      local ang = Angle(-28,0,0) + tr.Normal:Angle()
      ang:RotateAroundAxis(ang:Right(), -90)
      other:DispatchTraceAttack(dmg, self:GetPos() + ang:Forward() * 3, other:GetPos())
   end
end

if SERVER then
  function ENT:Think()
     if self.Stuck then return end

     local vel = self:GetVelocity()
     if vel == vector_origin then return end

     local tr = util.TraceLine({start=self:GetPos(), endpos=self:GetPos() + vel:GetNormal() * 20, filter={self.Entity, self:GetOwner()}, mask=MASK_SHOT_HULL})

     if tr.Hit and tr.HitNonWorld and IsValid(tr.Entity) then
        local other = tr.Entity
        if other:IsPlayer() then
           self:HitPlayer(other, tr)
        end
     end

     self.Entity:NextThink(CurTime())
     return true
  end
end

-- When this entity touches anything that is not a player, it should turn into a
-- weapon ent again. If it touches a player it sticks in it.
if SERVER then

   function ENT:PhysicsCollide(data, phys)
      if self.Stuck then return false end

      local other = data.HitEntity
      if not IsValid(other) and not other:IsWorld() then return end

      if other:IsPlayer() then
         local tr = util.TraceLine({start=self:GetPos(), endpos=other:LocalToWorld(other:OBBCenter()), filter={self.Entity, self:GetOwner()}, mask=MASK_SHOT_HULL})
         if tr.Hit and tr.Entity == other then
            self:HitPlayer(other, tr)
         end

         return true
      end
   end
end