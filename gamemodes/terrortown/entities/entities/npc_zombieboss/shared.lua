
if SERVER then
	AddCSLuaFile("shared.lua")
end

--local NPC = { Name = "Zombie Boss", Class = "npc_zombie", Model = "models/Zombie/Classic.mdl", Health = "6800", Category = Category } 

--list.Set( "NPC", "npc_zombieboss", NPC )

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.Model = Model("models/Zombie/Classic.mdl")
ENT.Spawnable 		= true

ENT.AutomaticFrameAdvance = true

ENT.Damage = 35
 
 
 local schdChase = ai_schedule.New( "AIFighter Chase" ) //creates the schedule used for this npc
 
 
	// Run away randomly (first objective in task)
	schdChase:EngTask( "TASK_GET_PATH_TO_RANDOM_NODE", 	128 )
	schdChase:EngTask( "TASK_RUN_PATH", 				0 )
	schdChase:EngTask( "TASK_WAIT_FOR_MOVEMENT", 	0 )
 
	// Find an enemy and run to it (second objectives in task)
	schdChase:AddTask( "FindEnemy", 		{ Class = "player", Radius = 2000 } )
	schdChase:EngTask( "TASK_GET_PATH_TO_RANGE_ENEMY_LKP_LOS", 	0 )
	schdChase:EngTask( "TASK_RUN_PATH", 				0 )
	schdChase:EngTask( "TASK_WAIT_FOR_MOVEMENT", 	0 )
 
	// Shoot it (third objective in task)
	schdChase:EngTask( "TASK_STOP_MOVING", 			0 )
	schdChase:EngTask( "TASK_FACE_ENEMY", 			0 )
	schdChase:EngTask( "TASK_ANNOUNCE_ATTACK", 		0 )
	schdChase:EngTask( "TASK_MELEE_ATTACK1", 		0 )
	//schedule is looped till you give it a different schedule
 
 
function ENT:Initialize()
 
	self:SetModel("models/Zombie/Classic.mdl")
	self:SetHullType( HULL_WIDE_HUMAN  );
	self:SetHullSizeNormal();
 
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
 
	self:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_WEAPON_MELEE_ATTACK1 | CAP_SQUAD  )
 
	self:SetMaxYawSpeed( 5000 )
 
 
	//don't touch stuff above here
	self:SetHealth(6800)
	self:SetModelScale( 1.5, 1.5, 1.5 )
	--self:Give( "weapon_ak47" ) //Can be given sweps.
 
end
 
 function ENT:OnTakeDamage(dmg)
  self:SetHealth(self:Health() - dmg:GetDamage())
  if self:Health() <= 0 then //run on death
  self:SetSchedule( SCHED_FALL_TO_GROUND ) //because it's given a new schedule, the old one will end.
  end
 end 
 
 
---------------------------------------------------------
--   Name: SelectSchedule
---------------------------------------------------------
function ENT:SelectSchedule()
 
	self:StartSchedule( schdChase ) //run the schedule we created earlier
 
end

function ENT:PhysicsCollide( data, physobj )
end

 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
 
	self.AutomaticFrameAdvance = bUsingAnim
 
end
