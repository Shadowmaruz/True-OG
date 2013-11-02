local CATEGORY_NAME = "Menus"

if ULib.fileExists( "lua/ulx/modules/cl/motdmenu.lua" ) or ulx.motdmenu_exists then
	CreateConVar( "motdfile", "ulx_motd.txt" ) -- Garry likes to add and remove this cvar a lot, so it's here just in case he removes it again.
	local function sendMotd( ply, showMotd )
		if showMotd == "1" then -- Assume it's a file
			if ply.ulxHasMotd then return end -- This player already has the motd
			if not ULib.fileExists( GetConVarString( "motdfile" ) ) then return end -- Invalid
			local f = ULib.fileRead( GetConVarString( "motdfile" ) )

			ULib.clientRPC( ply, "ulx.rcvMotd", false, f )

			ply.ulxHasMotd = true

		else -- Assume URL
			ULib.clientRPC( ply, "ulx.rcvMotd", true, showMotd )
			ply.ulxHasMotd = nil
		end
	end

	local function showMotd( ply )
		local showMotd = GetConVarString( "ulx_showMotd" )
		if showMotd == "0" then return end
		if not ply:IsValid() then return end -- They left, doh!

		sendMotd( ply, showMotd )
		ULib.clientRPC( ply, "ulx.showMotdMenu" )
	end
	hook.Add( "PlayerInitialSpawn", "showMotd", showMotd )

	function ulx.motd( calling_ply )
		if not calling_ply:IsValid() then
			Msg( "You can't see the motd from the console.\n" )
			return
		end

		if GetConVarString( "ulx_showMotd" ) == "0" then
			ULib.tsay( ply, "The MOTD has been disabled on this server." )
			return
		end

		showMotd( calling_ply )
	end
	local motdmenu = ulx.command( CATEGORY_NAME, "ulx motd", ulx.motd, "!motd" )
	motdmenu:defaultAccess( ULib.ACCESS_ALL )
	motdmenu:help( "Show the message of the day." )
	if SERVER then ulx.convar( "showMotd", "http://true-og.webs.com/information", " <0/1/(url)> - Shows the motd to clients on startup. Can specify URL here.", ULib.ACCESS_ADMIN ) end

end

if ULib.fileExists( "lua/ulx/modules/cl/changelogmenu.lua" ) or ulx.changelogmenu_exists then
	CreateConVar( "Changelogfile", "changelog.txt" ) -- Garry likes to add and remove this cvar a lot, so it's here just in case he removes it again.
	local function sendChangelog( ply, showChangelog )
		if showChangelog == "1" then -- Assume it's a file
			if ply.ulxHasChangelog then return end -- This player already has the motd
			if not ULib.fileExists( GetConVarString( "Changelogfile" ) ) then return end -- Invalid
			local f = ULib.fileRead( GetConVarString( "Changelogfile" ) )

			ULib.clientRPC( ply, "ulx.rcvChangelog", false, f )

			ply.ulxHasChangelog = true

		else -- Assume URL
			ULib.clientRPC( ply, "ulx.rcvChangelog", true, showChangelog )
			ply.ulxHasChangelog = nil
		end
	end

	local function showChangelog( ply )
		local showChangelog = GetConVarString( "ulx_showChangelog" )
		if showChangelog == "0" then return end
		if not ply:IsValid() then return end -- They left, doh!

		sendChangelog( ply, showChangelog )
		ULib.clientRPC( ply, "ulx.showChangelogMenu" )
	end
	--hook.Add( "PlayerInitialSpawn", "showMotd", showMotd )

	function ulx.changelog( calling_ply )
		if not calling_ply:IsValid() then
			Msg( "You can't see the motd from the console.\n" )
			return
		end

		if GetConVarString( "ulx_showChangelog" ) == "0" then
			ULib.tsay( ply, "The Changelog has been disabled on this server." )
			return
		end

		showChangelog( calling_ply )
	end
	local Changelogmenu = ulx.command( CATEGORY_NAME, "ulx changelog", ulx.changelog, "!changelog" )
	Changelogmenu:defaultAccess( ULib.ACCESS_ALL )
	Changelogmenu:help( "Show the server Changelog." )
	if SERVER then ulx.convar( "showChangelog", 1, " <0/1/(url)> - Shows the Changelog to clients on startup. Can specify URL here.", ULib.ACCESS_ADMIN ) end
else 
	ULib.tsay( ply, "Changelog doesnt exist ?." )
end	

if ULib.fileExists( "lua/ulx/modules/cl/bugsmenu.lua" ) or ulx.bugsmenu_exists then
	CreateConVar( "bugsfile", "bugs.txt" ) -- Garry likes to add and remove this cvar a lot, so it's here just in case he removes it again.
	local function sendbugs( ply, showbugs )
		if showbugs == "1" then -- Assume it's a file
			if ply.ulxHasbugs then return end -- This player already has the motd
			if not ULib.fileExists( GetConVarString( "bugsfile" ) ) then return end -- Invalid
			local f = ULib.fileRead( GetConVarString( "bugsfile" ) )

			ULib.clientRPC( ply, "ulx.rcvbugs", false, f )

			ply.ulxHasbugs = true

		else -- Assume URL
			ULib.clientRPC( ply, "ulx.rcvbugs", true, showbugs )
			ply.ulxHasbugs = nil
		end
	end

	local function showbugs( ply )
		local showbugs = GetConVarString( "ulx_showbugs" )
		if showbugs == "0" then return end
		if not ply:IsValid() then return end -- They left, doh!

		sendbugs( ply, showbugs )
		ULib.clientRPC( ply, "ulx.showbugsMenu" )
	end
	--hook.Add( "PlayerInitialSpawn", "showMotd", showMotd )

	function ulx.bugs( calling_ply )
		if not calling_ply:IsValid() then
			Msg( "You can't see the bugtracker from the console.\n" )
			return
		end

		if GetConVarString( "ulx_showbugs" ) == "0" then
			ULib.tsay( ply, "The BugTracker has been disabled on this server." )
			return
		end

		showbugs( calling_ply )
	end
	local bugsmenu = ulx.command( CATEGORY_NAME, "ulx bugs", ulx.bugs, "!bugs" )
	bugsmenu:defaultAccess( ULib.ACCESS_ALL )
	bugsmenu:help( "Show the server bug tracker." )
	if SERVER then ulx.convar( "showbugs", 1, " <0/1/(url)> - Shows the Changelog to clients on startup. Can specify URL here.", ULib.ACCESS_ADMIN ) end
else 
	ULib.tsay( ply, "bugtracker doesnt exist ?." )
end	