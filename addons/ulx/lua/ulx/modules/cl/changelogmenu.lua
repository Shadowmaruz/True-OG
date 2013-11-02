ulx.changelogmenu_exists = true

local isCUrl
local Curl

function ulx.showChangelogMenu()
	local window = vgui.Create( "DFrame" )
	if ScrW() > 640 then -- Make it larger if we can.
		window:SetSize( ScrW()*0.9, ScrH()*0.9 )
	else
		window:SetSize( 640, 480 )
	end
	window:Center()
	window:SetTitle( "True-OG TTT Change Log" )
	window:SetVisible( true )
	window:MakePopup()

	local html = vgui.Create( "HTML", window )

	local button = vgui.Create( "DButton", window )
	button:SetText( "Close" )
	button.DoClick = function() window:Close() end
	button:SetSize( 100, 40 )
	button:SetPos( (window:GetWide() - button:GetWide()) / 2, window:GetTall() - button:GetTall() - 10 )

	html:SetSize( window:GetWide() - 20, window:GetTall() - button:GetTall() - 50 )
	html:SetPos( 10, 30 )
	--if not isUrl then
		--html:SetHTML( ULib.fileRead( "data/changelog.txt" ) )
	--else
		html:OpenURL( "http://true-og.webs.com/change-log" ) --Curl 
	--end
end

function ulx.rcvChangelog( isCUrl_, text )
	isCUrl = isCUrl_
	if not isCUrl then
		ULib.fileWrite( "data/changelog.txt", text )
	else
		if text:find( "://", 1, true ) then
			Curl = text
		else
			Curl = "http://" .. text
		end
	end
end
