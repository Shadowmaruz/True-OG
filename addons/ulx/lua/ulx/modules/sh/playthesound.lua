if not(CLIENT) then return end

function playsoundpleaseokay(data)
        url = data:ReadString()
        if LocalPlayer().channel ~= nil && LocalPlayer().channel:IsValid() then
                LocalPlayer().channel:Stop()
        end
        sound.PlayURL(url,"",function(ch)
                if ch != nil and ch:IsValid() then
                        ch:Play()
                        LocalPlayer().channel = ch
                end
                end)
end

usermessage.Hook( "ulib_url_sound", playsoundpleaseokay )


function stopsoundpleaseokay(data)
        stopurl = data:ReadString()
        if LocalPlayer().channel ~= nil && LocalPlayer().channel:IsValid() then
                LocalPlayer().channel:Stop()
        end
        sound.PlayURL(stopurl,"",function(ch)
                if ch != nil and ch:IsValid() then
                        ch:Play()
                        LocalPlayer().channel = ch
                end
                end)
end

usermessage.Hook( "ulib_url_stopsound", stopsoundpleaseokay )



function stopmysongplease(data)
local stoppingsong = "You have stopped the URL for yourself."
LocalPlayer().channel:Stop()
	chat.AddText(Color(0,0,200),stoppingsong)
end

usermessage.Hook("stopmysongplease",stopmysongplease)