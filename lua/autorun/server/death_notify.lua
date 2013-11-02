  hook.Add("DoPlayerDeath", "ShowKiller", function(victim, attacker)
    if attacker:IsPlayer() and victim:GetRoleString() == attacker:GetRoleString() then
        victim:PrintMessage(HUD_PRINTTALK, "You have been killed by "..attacker:Nick()..". He was also a "..attacker:GetRoleString()..".")
	elseif attacker:IsPlayer() and victim:GetRoleString() != attacker:GetRoleString() then
		victim:PrintMessage(HUD_PRINTTALK, "You have been killed by a "..attacker:GetRoleString()..".")
	elseif not attacker:IsPlayer() then
        victim:PrintMessage(HUD_PRINTTALK, "You were not killed by a player.")
	end
end)