mpd_notify = nil
function mpdcron (mpdinf)
    if (mpd_notify) then
        naughty.destroy(mpd_notify)
    end
    local mpdtext = ""
    if (mpdinf.state=="play") then
        mpdtext = mpdinf.artist .. " - " .. mpdinf.title
    elseif (mpdinf.state=="pause") then
        mpdtext = " [[[ " .. mpdinf.artist .. " - " .. mpdinf.title .. " ]]]"
    else
        mpdtext = " [ leállítva ] "
    end
    mpd_notify = naughty.notify({
        text=(mpdinf.state=="pause" and "[[ PAUSED ]]\n" or "") .. 
            mpdinf.artist .. "\n" .. mpdinf.title,
        icon=DIRS["icons"] .. "/widgets/mpd.png",
        bg="#000000",
        timeout=3
    })
    textboxes["mpd"].text = awful.util.escape(mpdtext)
end
