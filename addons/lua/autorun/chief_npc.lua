local Category = "Halo 4"

local NPC = {	Name = "Master Chief - Good",
				Class = "npc_citizen",
				Model = "models/Halo4/Spartans/masterchief_npc.mdl",
				Health = "150",
				KeyValues = { citizentype = 4 },
				Category = Category }

list.Set( "NPC", "npc_masterchiefgood", NPC )

local Category = "Halo 4"

local NPC = {	Name = "Master Chief - Bad",
				Class = "npc_combine_s",
				Model = "models/Halo4/Spartans/masterchief_npc.mdl",
				Health = "150",
				Category = Category }

list.Set( "NPC", "npc_masterchiefbad", NPC )