globalkeys = {}

dopath("keybindings_function.lua")
require("keychains")

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () 
        urxvt_options("/home/users/zsolt/.config/urxvt/main.json")
    end)
))


timer_infopanel = timer{timeout=10}
timer_infopanel:connect_signal("timeout", function ()
    timer_infopanel:stop()
    wiboxes["userdata"].visible = false
end)

function urxvt_key(fn,info,cmd)
    return {
        func    =   function ()
            urxvt_options("/home/users/zsolt/.config/urxvt/" .. fn .. ".json",cmd)
        end,
        info    =   info
    }
end

globalkeys = awful.util.table.join(
    awful.key({ modkey }, "Escape", awful.tag.history.restore),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift" }, "q", function ()
        awesome.quit()
    end ),
    awful.key({modkey,"Shift"},"m",function() menubar.show() end),
    awful.key({winkey},"i",function()
        if (not wiboxes["userdata"].visible) then
            hook_get_fs_usage()
            hook_fs_usage()
            timer_infopanel:start()
        else
            timer_infopanel:stop()
        end
        wiboxes["userdata"].visible = not wiboxes["userdata"].visible
    end),
    awful.key({ modkey }, "l" , function () awful.tag.incmwfact(0.05) end),
    awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
    awful.key({ modkey }, "space", function () awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus(1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end),
    awful.key({ modkey }, "Tab", function () awful.client.focus.byidx(1); 
        if client.focus then client.focus:raise() end end),
    awful.key({ modkey, "Shift" }, "Tab", function () 
        awful.client.focus.byidx(-1); 
        if client.focus then client.focus:raise() end
    end)
)

keychains.init(globalkeys,
    { notify = {
        bg="#000000",
        position="bottom_left",
        icon_size=32
        },
      menu = {
          bg_normal = "#44444499",
          bg_focus  = "#002288cc",
          fg_normal = "#ffffff",
          fg_focus  = "#ffff00",
          border_color = "#111111",
          border_width = 2
      }
    }
)



-- *************************
-- Populate keychain tables
-- *************************
    -- awesome
    keychains.add({winkey},"a","Utils",DIRS["icons"] .. "/keychains/utils.png",{
        c   =   {
            func    =   function() awful.util.spawn("/usr/bin/speedcrunch") end,
            info    =   "Calculator"
        },
        t   =   {
            func    =   function() aw_translate() end,
            info    =   "Translate"
        },
        e   =   {
            func    =   function() aw_translate("hu en") end,
            info    =   "Translate to english"
        },
        a   =   {
            func    =   function() client_menu() end,
            info    =   "Applications"
        }
    })

    -- chromium
    keychains.add({winkey},"w","Web pages",DIRS["icons"] .. "/keychains/internet.png",{
        g   =   {
            func    =   function()
                open_url("https://mail.google.com/mail/u/0/#search/l%3Aunread")
            end,
            info    =   "Gmail - olvasatlan levelek"
        },
        m   =   {
            func    =   function()
                open_url("www.bgrg.mozanaplo.hu")
            end,
            info    =   "MozaNapló"
        },
        f   =   {
            func    =   function()
                open_url("www.facebook.com")
            end,
            info    =   "Facebook"
        },
        h   =   {
            func    =   function()
                open_url("http://hup.hu/user/4277/track")
            end,
            info    =   "HUP"
        }
    })

    -- informations
    keychains.add({winkey},"y","Informations",DIRS["icons"] .. "/keychains/info.png",{
        g   =   {
            func    =   info_mail,
            info    =   "Olvasatlan levelek"
        },
        r   =   {
            func    =   info_rss,
            info    =   "Olvasatlan hírek"
        },
        t   =   {
            func    =   info_torrent,
            info    =   "Torrent"
        },
        p   =   {
            func    =   info_packages,
            info    =   "Frissítések"
        },
        m   =   {
            func    =   info_mpd,
            info    =   "MPD"
        },

    })

    -- mpd
    keychains.add({winkey},"p","MPD",DIRS["icons"] .. "/keychains/tux-guitar.jpg",{
        p   =   {
            func    =   function () mpd_command("play") end,
            info    =   "Lejátszás"
        },
        s   =   {
            func    =   function () mpd_command("stop") end,
            info    =   "Stop"
        },
        space = {
            func    =   function () mpd_command("toggle") end,
            info    =   "Pause"
        },
        Right = {
            func    =   function () mpd_command("next") end,
            info    =   "Következő"
        },
        Left = {
            func    =   function () mpd_command("prev") end,
            info    =   "Előző"
        },
    })

    -- volume
    keychains.add({winkey},"v","Hangerő",DIRS["icons"] .. "/keychains/hangfal.png",{
        Up      =   {
            func    =   function () io.popen("amixer sset Master 10%+") end,
            info    =   "Master +10%"
        },
        Down    =   {
            func    =   function () io.popen("amixer sset Master 10%-") end,
            info    =   "Master -10%"
        },
        m       =   {
            func    =   function () io.popen("amixer sset Master toggle") end,
            info    =   "(Un)Mute Master"
        }
    })
    
    -- tags
    kc_move_tag   = {}
    --kc_change_tag = {}
    for _,i in pairs(tag_list) do
        kc_move_tag[i.hotkey] = {
            func    =   function() awful.client.movetotag(tags[i.name],client.focus) end,
            info    =   "<span color='white'>".. i.name .. "</span> " .. i.comment
        }
        --[[kc_change_tag[i.hotkey] = {
            func    =   function() awful.tag.viewonly(tags[i.name]) end,
            info    =   kc_move_tag[i.hotkey].info
        }]]
    end
    keychains.add({winkey},"m","Move to tag",DIRS["icons"] .. "/keychains/move.png",kc_move_tag)

    keychains.add({winkey},"t","Change tag",DIRS["icons"] .. "/keychains/jump.png",
        function()
            local mytag
            local ret={}
            local all_tags = awful.tag.gettags(1)
            for _,mytag in ipairs(all_tags) do
                if ( (mytag.name=="term") or (#(mytag:clients())>0 and awful.tag.selected(1).name~=mytag.name) ) then
                    if (tag_list[mytag.name]["hotkey"]) then
                        ret[tag_list[mytag.name]["hotkey"]] = {
                            func    =   function() 
                                awful.tag.viewonly(tags[mytag.name])
                            end,
                            info    =   "<span color='white'>".. 
                                mytag.name .. "</span> " .. tag_list[mytag.name]["comment"]
                        }
                    end
                end
            end
            return ret
        end
    )

    -- terminals
    keychains.add({winkey},"x","Terminálok",DIRS["icons"] .. "/keychains/terminal.png",{
        d   =   urxvt_key("dox","Dokumentumok"),
        v   =   urxvt_key("devel","Fejlesztés"),
        p   =   urxvt_key("pld","PLD"),
        a   =   urxvt_key("arch","Arch"),
        b   =   urxvt_key("bashburn","DVD burning","tmux -L burn -2 new-session; source-file /home/users/zsolt/.config/tmux/tmux-burn.conf"),
        t   =   urxvt_key("torrent","Transmission","transmission-remote-cli")
    },"menu")

keychains.start(5)

