-- Additional downloads not included in the normal files

-- Desert Hands
resource.AddFile("materials/models/weapons/v_models/hands/fas_hands_normal.vtf")
resource.AddFile("materials/models/weapons/v_models/hands/fas_hands2_normal.vtf")
resource.AddFile("materials/models/weapons/v_models/hands/fas_hands2.vtf")
resource.AddFile("materials/models/weapons/v_models/hands/fas_hands2.vmt")
resource.AddFile("materials/models/weapons/v_models/hands/fas_hands.vtf")
resource.AddFile("materials/models/weapons/v_models/hands/fas_hands.vmt")

-- Model Extras
resource.AddFile("materials/models/weapons/v_models/default_normal.vtf")
resource.AddFile("materials/models/weapons/v_models/large_normal.vtf")
resource.AddFile("materials/models/weapons/v_models/small_normal.vtf")

-- Grim Reaper Models
resource.AddFile("materials/models/grim/grim_normal.vtf")
resource.AddFile("materials/models/grim/grimbody.vmt")
resource.AddFile("materials/models/grim/grimbody.vtf")
resource.AddFile("materials/models/grim/mouth.vtf")
resource.AddFile("materials/models/grim/mouth.vmt")
resource.AddFile("materials/models/grim/mouth_normal.vtf")
resource.AddFile("materials/models/grim/skelface.vtf")
resource.AddFile("materials/models/grim/skelface.vmt")
resource.AddFile("materials/models/grim/skelface_normal.vtf")
resource.AddFile("materials/models/grim/skelface2.vtf")
resource.AddFile("materials/models/grim/skelface2.vmt")
resource.AddFile("materials/models/grim/skelface2_normal.vtf")
resource.AddFile("materials/models/grim/stimer.vtf")
resource.AddFile("materials/models/grim/stimer.vmt")
resource.AddFile("materials/models/grim/sythe.vtf")
resource.AddFile("materials/models/grim/sythe.vmt")
resource.AddFile("materials/models/grim/sythe_mask.vtf")

-- WaterWorld Textures
resource.AddFile("materials/maps/ttt_waterworld.vmt")
resource.AddFile("materials/maps/ttt_waterworld.vtf")

-- Same



local materials = {
	'dglz',
}

local sounds = {
	'music'
}

-- end

function resource.AddDir(dir)
	local f, d = file.Find(dir .. '/*', 'GAME')
	
	for k, v in pairs(f) do
		resource.AddSingleFile(dir .. '/' .. v)
	end
	
	for k, v in pairs(d) do
		resource.AddDir(dir .. '/' .. v)
	end
end

for _, mf in pairs(materials) do
	resource.AddDir('materials/' .. mf)
end
for _, mf in pairs(sounds) do
	resource.AddDir('sound/' .. mf)
end
