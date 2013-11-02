NPCsToSpawn = {}
SpawnCoords = {}
SpawnCoordsTimer = {}
SpawnTimer = {}
RespawnTimer = {}
WaveText = {}
RoundText = {}
MinDistance = 0
SpawnTimerBase = {}
SpawnUseBase = 0
ZombiezPerRound = 0
NumberOfPlayers = 0
Difficulty = 0
PerfectRounds = 1
CurrentRound = 1
AlivePlayers = 0
CurrentWave = 0
HPMod = 1
RoundPrep = 1
ScoreMultiplier = 1
CurrentZombiez = 0
TotalSpawnedZombiez = 0
MAXZOMBIEZ = 0
MaxSpawnsPerPlayer = 0
RevivalTimer = {}
PlayerPermDead = {}
-- This is where we will handle NPC deaths during the map, 
-- where we will apply score adjustments, 
-- and check if the round is done.


function OnNPCKilled( victim, killer, weapon )
	if not IsValid(victim) or not IsValid(killer) then return end

	local NPCType = victim:GetClass()
	local NPCName
	local PointsToAdd = 0
	if NPCType == "npc_zombie" then NPCName = "Zombie" PointsToAdd = 1
	elseif NPCType == "npc_headcrab" then NPCName = "Headcrab" PointsToAdd = 1
	elseif NPCType == "npc_headcrab_fast" then NPCName = "Fast Headcrab" PointsToAdd = 1
	elseif NPCType == "npc_headcrab_poison" then NPCName = "Poison Headcrab" PointsToAdd = 1
	elseif NPCType == "npc_zombie_fast" then NPCName = "Hunter Zombie" PointsToAdd = 2
	elseif NPCType == "npc_poisonzombie" then NPCName = "Carrier Zombie" PointsToAdd = 2
	elseif NPCType == "npc_combine_s" then NPCName = "Hazmat Soldier" PointsToAdd = 3
	elseif NPCType == "npc_strider" then NPCName = "Strider" PointsToAdd = 10
	elseif NPCType == "npc_antlion" then NPCName = "Antlion" PointsToAdd = 1
	elseif NPCType == "npc_antlionguard" then NPCName = "Antlion Guard" PointsToAdd = 15
	elseif NPCType == "npc_citizen" then NPCName = "Helper NPC" PointsToAdd = -50
	else NPCName = "Unregistered NPC Killed Please Report To Shadow!!!" Msg( victim:GetClass()  .. " was killed by " .. killer:GetName().. " with a " .. weapon:GetClass() .. ".\n" )
	end
	if NPCType != "npc_citizen" then
		if( CurrentZombiez > 0 ) then
			CurrentZombiez = CurrentZombiez - 1
		end
	end
	if killer:IsPlayer() then
		killer:AddFrags(PointsToAdd*ScoreMultiplier)
	else
		if PerfectRound == 1 then
			PerfectRound = 0
		end
	end
	if TotalSpawnedZombiez >= ZombiezPerRound then
		if CurrentZombiez == 0 then
			if RoundPrep == 0 then
				RoundPrep = 1
				timer.Simple( 3, function() 
					RoundText[2]:Display()
					timer.Simple( 3, function() 
						RoundText[1]:Display()
						timer.Simple( 3, function()
							CurrentRound = CurrentRound + 1
							WavePrep()
						end)
					end)
				end)
			end
		end
	end
end

function ZombieDifficulty(mode) -- Sigh...
	Difficulty = tonumber("mode")
	DifficultySetup()
end

function BedRevival(Activator)
	if IsValid(Activator) then
		local BedCoordz = Activator:GetPos()
		for k,v in pairs (player.GetAll()) do
			local corpse = corpse_find(v)
			if corpse and corpse == Activator then 
				if PlayerPermDead[v] != 1 then
					timer.Simple( 20, function() 
						if corpse and not v:IsAlive() then 
							if Activator:GetDistance(BedCoordz) <=50 then 
								Msg("Corpse IN A BED!")
								corpse_remove(corpse) 
								v:SpawnForRound( true ) 
								v:SetPos(BedCoordz) 
								v:SetHealth(1)
								v:PrintMessage( HUD_PRINTTALK,"-- You wake up beaten and bruised in an infirmary bed! --" )
								v:PrintMessage( HUD_PRINTTALK,"-- WARNING: Fall again within 60 seconds and you are dead! --" )
								RevivalTimer[v] = CurTime() + 60
							end 
						end 
					end)
				end
			end
		end
	end
end
		
function OnPlayerKilled (ply, infl, attacker) -- To Do: Screen Goes black slowly... at full black, player is dead
	if PerfectRound == 1 then
		PerfectRound = 0
	end
	if RevivalTimer[ply] > CurTime() then
		v:PrintMessage( HUD_PRINTTALK,"-- You fell again before the 60 second timer was up! Now you are totally dead! --" )
	end
	for _,v in pairs (player.GetAll()) do
		if PlayerPermDead[ply] == 1 then
			ply:PrintMessage( HUD_PRINTTALK,"-- " ..v:GetName().. " has died a horrible death!! --" )
		else
			ply:PrintMessage( HUD_PRINTTALK,"-- " ..v:GetName().. " has fallen! Bring them to a hospital bed to revive them! --" )
		end
	end
	if PlayerPermDead[ply] == 0 then
		timer.Simple( 0.1, function() 
			ply:Freeze(true)
			ply:Spectate(OBS_MODE_CHASE)
			local rag_ent = ply.server_ragdoll or ply:GetRagdollEntity()
			ply:SpectateEntity(rag_ent)
		end)
	end
end

-- This is where we will spawn in any spectators and set up all our round junk.

function WavePrep()
	for _, v in pairs (player.GetAll()) do
		if IsValid(v) and v:IsSpec() then
			v:Kill()
			v:ConCommand("ttt_spectator_mode 0")
			v:SpawnForRound( true )
			v:SetHealth(50)
			v:PrintMessage( HUD_PRINTTALK, "-- You stumble into the camp tired, hungry and beaten --" )
		end	
	end
	NPCsToSpawn = {}
	if CurrentRound == 1 then NPCsToSpawn[1] = "npc_zombie" 
	elseif CurrentRound == 2  then NPCsToSpawn[1] = "npc_zombie" 		NPCsToSpawn[2] = "npc_headcrab" 		
	elseif CurrentRound == 3  then NPCsToSpawn[1] = "npc_zombie" 		NPCsToSpawn[2] = "npc_headcrab_fast" 	
	elseif CurrentRound == 4  then NPCsToSpawn[1] = "npc_zombie" 		NPCsToSpawn[2] = "npc_headcrab" 		NPCsToSpawn[3] = "npc_headcrab_fast" Boss = 1  -- Boss
	elseif CurrentRound == 5  then NPCsToSpawn[1] = "npc_zombie" 		NPCsToSpawn[2] = "npc_headcrab" 		 
	elseif CurrentRound == 6  then NPCsToSpawn[1] = "npc_poisonzombie" 	NPCsToSpawn[2] = "npc_zombie" 			
	elseif CurrentRound == 7  then NPCsToSpawn[1] = "npc_poisonzombie"	NPCsToSpawn[2] = "npc_headcrab" 		
	elseif CurrentRound == 8  then NPCsToSpawn[1] = "npc_poisonzombie"	NPCsToSpawn[2] = "npc_headcrab_fast" 	
	elseif CurrentRound == 9  then NPCsToSpawn[1] = "npc_poisonzombie" 	NPCsToSpawn[2] = "npc_zombie" 			NPCsToSpawn[3] = "npc_headcrab_fast" 
	elseif CurrentRound == 10 then NPCsToSpawn[1] = "npc_poisonzombie" 	NPCsToSpawn[2] = "npc_zombie" 			NPCsToSpawn[3] = "npc_headcrab_posion" Boss = 1  -- Boss
	elseif CurrentRound == 11 then NPCsToSpawn[1] = "npc_zombie_fast" 	NPCsToSpawn[2] = "npc_zombie" 			
	elseif CurrentRound == 12 then NPCsToSpawn[1] = "npc_zombie_fast" 	NPCsToSpawn[2] = "npc_headcrab_fast" 	
	elseif CurrentRound == 13 then NPCsToSpawn[1] = "npc_zombie_fast" 	NPCsToSpawn[2] = "npc_zombie" 			NPCsToSpawn[3] = "npc_headcrab_poison" 
	elseif CurrentRound == 14 then NPCsToSpawn[1] = "npc_zombie_fast" 	NPCsToSpawn[2] = "npc_headcrab_poison" 	NPCsToSpawn[3] = "npc_headcrab_fast" 
	elseif CurrentRound == 15 then NPCsToSpawn[1] = "npc_zombie_fast" 	NPCsToSpawn[2] = "npc_poisonzombie" 	NPCsToSpawn[3] = "npc_headcrab_fast" Boss = 1 NPCsToSpawn[4] = "npc_zombie"  -- Boss
	else
	end
	CountPlayers()
end
 -- This is how we will determine round ending. 
 -- As well as making sure players dont have jetpacks ;) 
 -- Called from the map every 0.5 second

function AutoRunner()
	SpawnZombiez ( "npc_zombie" ) 
	local TempAlivePlayers = 0
	SetGlobalFloat("ttt_round_end", 60*60+CurTime())
	SetGlobalFloat("ttt_haste_end", 60*60+CurTime())
	for _, w in pairs( player.GetAll() ) do 
		if w and w:IsValid() and w:Alive() then
			TempAlivePlayers = TempAlivePlayers + 1
			if w:FlashlightIsOn() then
				w:Flashlight( false )
			end
			if w:GetNWFloat("JetPack") == 1 then
				w:SetNWFloat("JetPack", 0)
				w:SetNWFloat("JetFuel", 0)
				w:PrintMessage( HUD_PRINTTALK, "NOTICE: JetPacks are disabled on this map! You're better to use a backpack anyway!" )
			end
		end
	end
	AlivePlayers = TempAlivePlayers
	if AlivePlayers == 0 and RoundPrep == 0 then RoundPrep = 1 timer.Simple( 2, function() EndRound(WIN_ZOMBIE) end) end
end
		
function SelectChosenOne()
	for _, w in RandomPairs( player.GetAll() ) do 
		if w and w:IsValid() and w:Alive() then
			w:SetPos(Vector(0, -256, -1020) )
			w:PrintMessage( HUD_PRINTTALK, "NOTICE: You have been chosen to choose the difficulty for this event!" )
			-- 0,0,20 Center of map spawn
			return
		end
	end
end

function DifficultySetup()
	if Difficulty == 0 then -- Easy Difficulty
		MAXZOMBIEZ = 60
		MaxSpawnsPerPlayer = 4
		MinDistance = 300
		SpawnTimerBase[1] = 8 + CurTime()
		SpawnTimerBase[2] = 10 + CurTime()
		SpawnTimerBase[3] = 13 + CurTime()
		SpawnTimerBase[4] = 17 + CurTime()
		SpawnUseBase = 12 + CurTime()
		ZombiezPerRound = 60 * NumberOfPlayers
		HPMod = 0.5
		ScoreMultiplier = 0.75
	elseif Difficulty == 1 then -- Normal Difficulty
		MAXZOMBIEZ = 80
		MaxSpawnsPerPlayer = 6
		MinDistance = 150
		SpawnTimerBase[1] = 6 + CurTime()
		SpawnTimerBase[2] = 8 + CurTime()
		SpawnTimerBase[3] = 10 + CurTime()
		SpawnTimerBase[4] = 13 + CurTime()
		SpawnUseBase = 10 + CurTime()
		ZombiezPerRound = 80 * NumberOfPlayers
		HPMod = 1
		ScoreMultiplier = 1
	elseif Difficulty == 2 then -- Hard Difficulty
		MAXZOMBIEZ = 100
		MaxSpawnsPerPlayer = 8
		MinDistance = 75 + CurTime()
		SpawnTimerBase[1] = 4 + CurTime()
		SpawnTimerBase[2] = 6 + CurTime()
		SpawnTimerBase[3] = 8 + CurTime()
		SpawnTimerBase[4] = 10 + CurTime()
		SpawnUseBase = 8 + CurTime()
		ZombiezPerRound = 100 * NumberOfPlayers
		HPMod = 1.5
		ScoreMultiplier = 1.75
	else 				  -- Nightmare Difficulty
		MAXZOMBIEZ = 125
		MaxSpawnsPerPlayer = 15
		MinDistance = 25
		SpawnTimerBase[1] = 2 + CurTime()
		SpawnTimerBase[2] = 4 + CurTime()
		SpawnTimerBase[3] = 6 + CurTime()
		SpawnTimerBase[4] = 8 + CurTime()
		SpawnUseBase = 5 + CurTime()
		ZombiezPerRound = 200 * NumberOfPlayers
		HPMod = 3
		ScoreMultiplier = 5
	end
	CurrentZombiez = 0
	TotalSpawnedZombiez = 0
	WavePrep()
	if(RoundPrep == 1) then 
		for v, p in pairs ( NPCsToSpawn ) do
			if p then
				timer.Simple( v, function() 
					SpawnZombiez ( p ) 
				end ) 
			end
		end 
		RoundPrep = 0 
	end
end

-- This function is to be used to count alive players, 

function CountPlayers() -- For auto difficulty updating
	local TempPlayerNum = 0
	for k, w in pairs( player.GetAll() ) do 
		if w and w:IsValid() then
			TempPlayerNum = TempPlayerNum + 1
			if w:Alive() then
				PlayerPermDead[w] = 0
				RevivalTimer[w] = 0
				AlivePlayers = AlivePlayers + 1
			end
		end
	end
	NumberOfPlayers = TempPlayerNum
	Msg("There are " ..TempPlayerNum.. " Players!")
end
function ZombieInit() -- Called on map prep 
	--ttt_minimum_players = 1
	ttt_debug_preventwin = 1
	-- Set up difficulties
	CountPlayers()
	-- Register SpawnsPoints
	for k, w in pairs( ents.FindByClass("info_npc_spawn_destination") ) do
		Msg("GOT A SPAWN!")
		SpawnCoords[k] = w:GetPos()
		SpawnCoordsTimer[k] = CurTime()
	end
	for k, w in pairs( ents.FindByClass("game_text") ) do
		if(w:GetName() == "Wave1Text") then
			WaveText[1] = w
		elseif(w:GetName() == "Wave2Text") then
			WaveText[2] = w
		elseif(w:GetName() == "Wave3Text") then
			WaveText[3] = w
		elseif(w:GetName() == "Wave4Text") then
			WaveText[4] = w
		elseif(w:GetName() == "Wave5Text") then
			WaveText[5] = w
		elseif(w:GetName() == "Wave6Text") then
			WaveText[6] = w
		elseif(w:GetName() == "WavePrep") then
			RoundText[1] = w
		elseif(w:GetName() == "WaveEnd") then
			RoundText[2] = w
		else end
	end	
	CurrentRound = 1
end
function SpawnZombiez( Entity ) 
	Msg("Spawn Start!")
	if(CurrentZombiez < MAXZOMBIEZ) then
		Msg("NOT MAXIEZ!!.")
		for a, b in pairs (NPCsToSpawn) do
			Msg("Maybe ? Ya Go!.")
			if SpawnTimerBase[a] <= CurTime() then
				if Entity then
					Msg("Off Ya Go!.")
					-- Locate All Players, Calculate distances, and Spawn the NPC
					for k, w in pairs( player.GetAll() ) do
						if w and w:IsValid() and w:Alive() then
						Msg("Got Ya PLR!.")
							local i = 0
							for j, v in pairs( SpawnCoords ) do
								Msg("Cycle Spawnz.")
								if SpawnCoordsTimer[j] <= CurTime() then
									Msg("Found One!!.")
									if i >= MaxSpawnsPerPlayer then Msg("MAX SPAWNS REACHED!\n") break end
									if not w:GetPos():Distance(Vector(SpawnCoords[j])) then break end
									if w:GetPos():Distance(Vector(SpawnCoords[j])) >= MinDistance and w:GetPos():Distance(Vector(SpawnCoords[j])) <= 3000 then
										Msg("FIRE DA SPAWNZ.")
										i = i + 1
										newEnt = ents.Create( Entity )
										newEnt:SetPos( SpawnCoords[j] ) -- Note that the position can be overridden by the user's flags
										newEnt:Spawn()
										newEnt:Activate()
										newEnt:SetMaxHealth(newEnt:GetMaxHealth()*HPMod)
										newEnt:SetHealth(newEnt:GetMaxHealth())
										newEnt:NavSetGoal(Vector(37, -95, -20))
										SpawnCoordsTimer[v] = CurTime() + SpawnUseBase -- Timer so we wont use this spawn for X seconds again (Defined in Init)
										CurrentZombiez = CurrentZombiez + 1 -- Need to keep track of live zombiez
										TotalSpawnedZombiez = TotalSpawnedZombiez + 1
									end
								end
								SpawnCoordsTimer[v] = CurTime() + SpawnUseBase 
							end
						end
					end
				end
			end
			SpawnTimer[a] = CurTime() + SpawnTimerBase[a]
		end
	end
end
hook.Add( "OnNPCKilled", "OnNPCKilled", OnNPCKilled );
hook.Add( "OnPlayerDeath", "OnPlayerKilled", OnPlayerKilled );