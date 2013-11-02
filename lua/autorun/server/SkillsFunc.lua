if SERVER then AddCSLuaFile(SkillsFunc.lua) end
function KeenInstincts()
	for _ , play in pairs (player.GetAll()) do
		if play:SteamID() == "STEAM_0:1:47635141" then
			play:SetNWFloat("KeenInstincts",50)
			play:PrintMessage( HUD_PRINTTALK,"Activated!" )
		end
	end
end

function AlwaysPrepared (ply)
	if ply and ply:IsPlayer()
	end
end
