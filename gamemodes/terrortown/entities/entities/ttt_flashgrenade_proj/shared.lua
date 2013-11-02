

if SERVER then
   AddCSLuaFile("shared.lua")
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

local FLASH_INTENSITY = 4000
local FlashSound = Sound("npc/assassin/ball_zap1.wav")

function ENT:Explode(tr)
local pos = self.Entity:GetPos()
	if SERVER then
		self.Entity:SetNoDraw(true)
		self.Entity:SetSolid(SOLID_NONE)

      -- pull out of the surface
		if tr.Fraction != 1.0 then
			self.Entity:SetPos(tr.HitPos + tr.HitNormal * 0.6)
		end


		-- make sure we are removed, even if errors occur later
		self:Remove() 

		local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)

		if tr.Fraction != 1.0 then
			effect:SetNormal(tr.HitNormal)
		end
      
		util.Effect("Explosion", effect, true, true)
		util.Effect("cball_explode", effect, true, true)

		sound.Play(FlashSound, pos, 100, 100)
	else
		local spos = self.Entity:GetPos()
		local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
		util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

		self:SetDetonateExact(0)
	end
	FlashBEffect(pos)
end

function FlashBEffect(Position)
	local radius = 300
	for k, target in pairs(ents.FindInSphere(Position, radius)) do
		if IsValid(target) then
			--local tpos = target:LocalToWorld(target:OBBCenter())
			--local dir = (tpos - Position):GetNormal()
			--local phys = target:GetPhysicsObject()
			if target:IsPlayer() then
	
				local dist = target:GetShootPos():Distance( Position ) 
				local endtime = (FLASH_INTENSITY / (dist * 2))*2;
				if (endtime > 15) then
					endtime = 15;
				elseif (endtime < 1) then
					endtime = 0;
				end

				simpendtime = math.floor(endtime);
				tenthendtime = math.floor((endtime - simpendtime) * 10);

	--			if (pl:GetNetworkedFloat("FLASHED_END") > CurTime()) then
	--				pl:SetNetworkedFloat("FLASHED_END", endtime + pl:GetNetworkedFloat("FLASHED_END") + CurTime() - pl:GetNetworkedFloat("FLASHED_START"));
	--			else
				target:SetNetworkedFloat("FLASHED_END", endtime + CurTime());
	--			end

				target:SetNetworkedFloat("FLASHED_END_START", CurTime());
				
/*				if target:GetNetworkedFloat("FLASHED_END") > CurTime() then	
	
					local FlashedEnd 	= target:GetNetworkedFloat("FLASHED_END")
					local FlashedStart 	= target:GetNetworkedFloat("FLASHED_START")
					
					local Alpha
					local FlashAlpha = 0
					--if(FlashedEnd - CurTime() > FLASHTIMER) then
					--	Alpha = 150;
					--else
						FlashAlpha = 1 - (CurTime() - (FlashedEnd - 6)) / (FlashedEnd - (FlashedEnd - 6));
						Alpha = FlashAlpha * 150;
					--end
					if CLIENT then
						target.surface.SetDrawColor(255, 255, 255, math.Round(Alpha))
						target.surface.DrawRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight())
						--if (FlashedEnd > CurTime() and FlashedEnd - 1 - CurTime() <= 6) then
							--FlashAlpha = 1 - (CurTime() - (FlashedEnd - 6)) / (6);
							--DrawMotionBlur( 0, FlashAlpha / ((6 + 1) / (6 * 4)), 0);
						--elseif (FlashedEnd > CurTime()) then
						
							DrawMotionBlur( 0.1, 0.79, 0.05);
						--else
						--	DrawMotionBlur( 0, 0, 0);
						--end
						hook.Add( "RenderScreenspaceEffects", "FlashBEffectStun", FlashBEffect)
						hook.Add("HUDPaint", "FlashBEffectDraw", FlashBEffect)
					end	
				end */
			end
		end
	end
	if SERVER then
		local phexp = ents.Create("env_physexplosion")
		if IsValid(phexp) then
			phexp:SetPos(Position)
			phexp:SetKeyValue("magnitude", 100) --max
			phexp:SetKeyValue("radius", radius)
			-- 1 = no dmg, 2 = push ply, 4 = push radial, 8 = los, 16 = viewpunch
			phexp:SetKeyValue("spawnflags", 1 + 2 + 16)
			phexp:Spawn()
			phexp:Fire("Explode", "", 0.2)
		end
	end
end
