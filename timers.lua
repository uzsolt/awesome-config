dopath("timerfuncs.lua")

timers = {}

timerfunc = {}

timerfunc[1] = function ()
    --set_wibox_widgets()
    hook_change_to_web()
    --uzsolt_mpd:mpd_update()
end

--[[
timerfunc[10] = function ()
    --hook_network()
    hook_get_fs_usage()
    hook_fs_usage()
end
]]

timerfunc[60] = function ()
    hook_arch_update()
    hook_rss()
    hook_gmail()
end

for i,j in pairs(timerfunc) do
    if not timers[i] then
        j()
        timers[i] = timer{timeout=i}
        timers[i]:connect_signal("timeout", function ()
            j()
        end)
        timers[i]:start()
    end
end

