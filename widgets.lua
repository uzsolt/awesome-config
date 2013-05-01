function create_widgets(mytable,widgettype)
    result = {}
    for name,tb in pairs(mytable) do
        if (widgettype == "launcher") then 
            result[name] = awful.widget.launcher(tb)
        elseif (widgettype == "graph") then
            result[name] = awful.widget.graph()
            if (tb["width"]) then
                result[name]:set_width(tb["width"])
            end
            --[[
            if (tb["label"]) then
                result[name]:set_show_text(true)
                result[name]:set_label(tb["label"])
            end
            ]]
            if (tb["gr_colors"]) then
                --result[name]:set_gradient_colors(tb["gr_colors"])
            end
            if (tb["gr_angle"]) then
                --result[name]:set_gradient_angle(tb["gr_angle"])
            end
            if (tb["max_value"]) then
                --result[name]:set_scale(true)
                result[name]:set_max_value(math.floor(tb["max_value"]))
            end
            if (tb["height"]) then
                result[name]:set_height(tb["height"])
            end
        elseif (widgettype == "textclock") then
            result[name] = awful.widget.textclock(tb["format"] or "%H:%M",tonumber(tb["timeout"]) or 30)
            if tb["align"] then
                result[name]:set_align(tb["align"])
            end
            --[[
            for vname,value in pairs(tb) do
                result[name][vname] = value
            end
            ]]
        else
            if (widgettype=="textbox") then
                result[name] = wibox.widget.textbox()
            elseif (widgettype=="imagebox") then
                result[name] = wibox.widget.imagebox()
                if tb.image then
                    result[name]:set_image(tb.image)
                end
            end
            if tb["width"] then
                result[name]:fit(tb["width"],10)
            end
            if tb["align"] then
                result[name]:set_align(tb["align"])
            end
        end
    end
    return result
end

textbox_data = {
    ["arch"] = {
    },
    ["mem"] = {
    },
    ["battery"] = {
        width = 35,
    },
    ["net_down"] = {
        width = 35,
    },
    ["net_up"] = {
        width = 35,
    },
    ["disk_usage"] = {
        width = 1000,
    },
    ["uptime"] = {
        align = "left",
        width = 120,
    },
    ["wlan"] = {
        width = 120,
    },
    ["mpd"] = {
        bg = "#00000066",
        fg = "#ff0000",
        width = 500,
    },
    ["rss"] = {
        bg = "#000000aa",
        width = 25,
    },
    ["cpu1"] = {
        width = 25,
    },
    ["cpu2"] = {
        width = 30,
        align = "right",
    },
    ["cpu3"] = {
        width = 30,
        align = "right",
    },
    ["cpu0_freq"] = {
        width = 60,
    },
    ["cpu1_freq"] = {
        width = 60,
    },
    ["load"] = {
        width = 100
    },
    ["gmail"] = {
        bg = "#000000aa",
        width = 20
    },
}

function ib_Image(file)
    local img
    if (file:sub(1,1)=="/") then
        --img = image(file)
        img = file
    else
        img = GetImage("widgets/" .. file)
    end
    return img
end

iconbox_data = {
    ["cpu"] = {
        image = DIRS["home"] .. "/icons/iconboxes/CPU-AMD-icon.png"
    },
    ["mem"] = {
        image = ib_Image("System-Memory-icon.png")
    },
    ["battery"] = {
    },
    ["battery_charge"] = {
    },
    ["arch"] = {
        image = ib_Image(DIRS["home"] .. "/icons/iconboxes/Arch_logo.png")
    },
    --[[
    ["mpd"] = {
        image = ib_Image("/usr/share/icons/AwOken/clear/128x128/apps/musique.png")
    },
    ]]
    ["network"] = {
        image = ib_Image("Wireless-icon.png")
    },
    ["net_down"] = {
        image = DIRS["home"] .. "/icons/iconboxes/download.png"
    },
    ["net_up"] = {
        image = DIRS["home"] .. "/icons/iconboxes/upload.png"
    },
    ["disk_usage"] = {
        image = DIRS["home"] .. "/icons/iconboxes/Filesystems-hd-linux-icon.png"
    },
    ["rss"] = {
        image = ib_Image(DIRS["home"] .. "/icons/iconboxes/RSS-icon.png")
    },
    --[[
    ["euro"] = {
        image = GetImage("g2k-top-euro.gif")
    },
    ]]
    ["uptime"] = {
        image = DIRS["home"] .. "/icons/iconboxes/It-Infrastructure-Linux-client-icon.png"
    },
    --[[
    ["date"] = {
        image = ib_Image("Calender-icon-2.png")
    },
    ]]
    ["gmail"] = {
        image = DIRS["home"] .. "/icons/iconboxes/Gmail-icon.png"
    },
    ["time"] = {
        image = ib_Image(DIRS["home"] .. "/icons/iconboxes/clock.png")
    },
    ["top"] = {
        image = DIRS["home"] .. "/icons/iconboxes/top.png"
    }
}


graph_data = {
    ["cpu1"] = {
        width = 20,
        gr_colors = {"#33ff25","#889925","#ff3325"},
        gr_angle = 180,
    },
    ["cpu2"] = {
        width = 20,
        gr_colors = {"#33ff25","#889925","#ff3325"},
        gr_angle = 180,
        height = 10,
    },
    ["cpu3"] = {
        width = 20,
        gr_colors = {"#33ff25","#889925","#ff3325"},
        gr_angle = 180,
        height = 10,
    },
    ["net_down"] = {
        width = 20,
        max_value = 1500,
        height=26,
        gr_colors = {"#009966","#416e58","#6c6a65"},
        gr_angle = 180
    },
    ["net_up"] = {
        width = 20,
        max_value = 70,
        height=26,
        gr_colors = {"#009966","#416e58","#6c6a65"},
        gr_angle = 180,
    }
}

textclock_data = {
    ["time"] = {
        width = 120,
        format = "<span color='#00ff00'>%H:%M:%S</span>",
        timeout = 1,
        align="center"
    },
    ["date"] = {
        width = 120,
        format = "<span color='#006600'>%b. %d., %A</span>",
        timeout = 60,
        align="center"
    },
}

media_launcher_data= {}
for _,mbutton in pairs({"prev","play","pause","stop","next"}) do
    media_launcher_data["media_" .. mbutton] = {
        image = ib_Image(icondir .. "actions/stock_media-" .. mbutton .. ".png"),
        command = "mpc " .. ((mbutton=="pause") and "toggle" or mbutton) ,
    }
end

textboxes = create_widgets(textbox_data,"textbox")
iconboxes = create_widgets(iconbox_data,"imagebox")
graphs    = create_widgets(graph_data,"graph")
clocks    = create_widgets(textclock_data,"textclock")

graphs["cpu1"]:set_color(
    {
        type="linear",
        from={0,0},to={0,100},
        stops = {
            {0,"#00ff00"},
            {100,"#ff0000"}
        }
    }
)
graphs["net_up"]:set_background_color("#22222233")
graphs["net_down"]:set_background_color("#00000033")

textboxes["cpu1"].fit = function(widget,w,h) return 27,h end
textboxes["cpu2"].fit = function(widget,w,h) return 30,10 end
textboxes["cpu3"].fit = function(widget,w,h) return 30,10 end
textboxes["cpu0_freq"].fit = function(widget,w,h) return 55,h end
textboxes["cpu1_freq"].fit = function(widget,w,h) return 55,h end
textboxes["net_down"].fit = function(widget,w,h) return 27,10 end
textboxes["net_up"].fit = function(widget,w,h) return 27,10 end

gmailbuttons =
    awful.util.table.join(
        awful.button({}, 1, function()
            run_background("chromium https://mail.google.com/mail/u/0/#search/l%3Aunread",
                function ()
                    -- we are happy if end, nothing to do
                end)
        end),
        awful.button({}, 3, function()
            run_background(DIRS["home"] .. "/bin/gmail-check",function()
                hook_gmail()
            end)
        end)
    )

textboxes["gmail"]:buttons(gmailbuttons)
iconboxes["gmail"]:buttons(gmailbuttons)

tooltip = {}

tooltip["arch"] = awful.tooltip({
    objects = { iconboxes["arch"],textboxes["arch"] },
    timer_function = function()
        local ret = ""
        local f = io.open(DIRS["home"] .. "/logfiles/pacman.update")
        s = f:read("*line")
        while (s) do
            ret = ret .. "\n > " .. s
            s = f:read("*line")
        end
        f:close()
        ret = "Frissítendő csomagok\n" .. ret
        return ret
    end,
})

tooltip["top"] = awful.tooltip({
    objects = {iconboxes["top"]},
    timer_function = function()
        function color(nr,str)
            return "<span color='" .. 
                ( (tonumber(nr)>0) and "lightgreen" or "gray" ) .. "'>" ..
                str .. "</span>"
        end
        return color(#update_packs,"Új csomag: " .. #update_packs) .. "\n" ..
            color(#emails,"Olvasatlan email: " .. #emails) .. "\n" ..
            color(unread_rss,"Olvasatlan hír: " .. unread_rss)
    end
})

tooltip["bat"] = awful.tooltip({
    objects = {textboxes["battery"],iconboxes["battery"]},
    timer_function = function()
        f = io.popen("acpi -b -i")
        return f:read("*all")
    end
})

--[[
tooltip["mpd"] = awful.tooltip({
    objects = {textboxes["mpd"]},
    timer_function = function()
        local st = uzsolt_mpd:get_state()
        if (st=="play") or (st=="pause") then
            return uzsolt_mpd:get_artist_title_or_filename()
        else
            return awful.util.escape(" [ Leállítva ] ")
        end
    end
})
]]

--[[
tooltip["todo"] = awful.tooltip({
    objects = { clocks["date"] },
    timer_function = function()
        local colors = {
            L   =   "grey",
            M   =   "yellow",
            H   =   "red",
        }
        local tasks = taskwarrior_parse()
        table.sort(tasks,function(a,b)
            -- a<b
            local ret
            if (a["priority"]~=b["priority"]) then
                if (a["priority"]=="H") then
                    ret = true
                elseif (b["priority"]=="H") then
                    ret = false
                elseif (a["priority"]=="M") then
                    ret = true
                else
                    ret = false
                end
            else
                ret = (a["description"]<b["description"])
            end
            return ret
        end)
        local task
        local todo_string = ""
        for _,task in pairs(tasks) do
            todo_string = todo_string .. "<span color='" .. colors[(task["priority"] or "L")] .. "'>"..
                task["description"] .. 
                "</span>" .. ( (task["project"]) and (" (" .. task["project"] .. ")") or "" ) .. "\n"
        end
        return todo_string
    end,
})
]]

tooltip["load"] = awful.tooltip({
    objects = { textboxes["load"] },
    timer_function = function()
        local max = 200
        local f = io.popen("ps -eo pcpu,args --sort -pcpu")
        s = ""
        local colors = { "red" , "yellow" , "lightgreen" }
        f:read("*line")
        for i=1,3 do
            local sl = f:read("*line")
            if (i>1) then
                s = s .. "\n"
            end
            s = s .. coloring(
                awful.util.escape(sl:sub(sl:find("%d+.%d+ %S+"))),
                colors[i]
            )
        end
        f:close()
        return s
    end
})

tooltip["mem"] = awful.tooltip({
    objects = { textboxes["mem"],iconboxes["mem"] },
    timer_function = function()
        local function kerekit(x)
            return math.floor(x/1048576*100)/100
        end
        local line, k, v, mem 
        mem = {}
        for line in io.lines("/proc/meminfo") do
            for k,v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
                if      k=="MemTotal"   then mem.mtotal  = kerekit(v)
                elseif  k=="MemFree"    then mem.mfree   = kerekit(v)
                elseif  k=="SwapTotal"  then mem.stotal  = kerekit(v)
                elseif  k=="SwapFree"   then mem.sfree   = kerekit(v)
                end
            end
        end

        return "Mem:  " .. mem.mtotal-mem.mfree .. "Gb / " .. mem.mtotal .. "Gb\nSwap: " .. mem.stotal-mem.sfree .. "Gb / " .. mem.stotal .. "Gb"
    end
})


-- {{{ Statusbar
-- Create a taglist widget
mytaglist = awful.widget.taglist(1, 
    awful.widget.taglist.filter.noempty,
    awful.util.table.join(
        awful.button({}, 1, awful.tag.viewonly), 
        awful.button({modkey}, 1, awful.client.movetotag)
    )
)

mytasklist = awful.widget.tasklist(
    1,
    awful.widget.tasklist.filter.currenttags,
    awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ }, 3, function (c) 
            naughty.notify({text=c.name})
        end)
    )
)

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
mylayoutbox = awful.widget.layoutbox(1)
mylayoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () 
        awful.layout.inc(layouts, 1)
        hook_arrange(1)
    end),
    awful.button({ }, 3, function () 
        awful.layout.inc(layouts, -1) 
        hook_arrange(1)
    end)
))
--mylayoutbox.image = image("/usr/share/awesome/themes/default/layouts/tilew.png")

mypromptbox = awful.widget.prompt()

-- create systray
mysystray = wibox.widget.systray()

