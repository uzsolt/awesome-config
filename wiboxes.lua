space = wibox.widget.textbox()
space.fit = function(widget,w,h) return 22,h end

small_space = wibox.widget.textbox()
small_space.width = 5

wiboxes = {}

-- Top wibox
wiboxes["top"] = awful.wibox (
    {
        position = "top", 
        bg = "#22222233",
        height = 26,
    }
)
local top_layout = wibox.layout.fixed.horizontal()

local sublayouts = {}
sublayouts["clock"] = wibox.layout.flex.vertical()
sublayouts["clock"]:add(clocks["time"])
sublayouts["clock"]:add(clocks["date"])

sublayouts["cpu"] = wibox.layout.flex.vertical()
for i=2,3 do
    sublayouts["cpu" .. i] = wibox.layout.fixed.horizontal()
    sublayouts["cpu" .. i]:add(graphs["cpu"..i])
    sublayouts["cpu" .. i]:add(textboxes["cpu"..i])
    sublayouts["cpu" .. i]:add(textboxes["cpu" .. i-2 .. "_freq"]) 
    sublayouts["cpu"]:add(sublayouts["cpu" .. i])
end

sublayouts["tag_task_list"] = wibox.layout.fixed.horizontal()
sublayouts["tag_task_list"]:add(mytaglist)
sublayouts["tag_task_list"]:add(space)

sublayouts["net"] = wibox.layout.flex.vertical()
sublayouts["net_up"] = wibox.layout.fixed.horizontal()
sublayouts["net_down"] = wibox.layout.fixed.horizontal()
for _,i in ipairs{"net_up","net_down"} do
    sublayouts[i]:add(iconboxes[i])
    sublayouts[i]:add(textboxes[i])
    sublayouts[i]:add(graphs[i])
end
sublayouts["net"]:add(sublayouts["net_up"])
sublayouts["net"]:add(sublayouts["net_down"])

for _,i in ipairs {
 
    iconboxes["top"],
    textboxes["load"],
    iconboxes["cpu"],

    graphs["cpu1"],
    textboxes["cpu1"],
    sublayouts["cpu"],
    space, space,
    iconboxes["time"],
    sublayouts["clock"],
    iconboxes["network"],
    textboxes["wlan"],
    sublayouts["net"],
    space,
    sublayouts["tag_task_list"],
    textboxes["mpd"]
} do
    top_layout:add(i)
end
wiboxes["top"]:set_widget(top_layout)

wiboxes["userdata"] = awful.wibox(
    {
        position="top",
        height=25,
        width=1366,
        bg = "#000000bb"
    }
)
wiboxes["userdata"].visible = false

userdata_layout = wibox.layout.fixed.horizontal()
for _,i in ipairs({
    mylayoutbox,
    iconboxes["arch"],
    textboxes["arch"],
    space,
    iconboxes["rss"],
    textboxes["rss"],
    iconboxes["gmail"],
    textboxes["gmail"],
    space,
    mysystray,
    iconboxes["mem"],
    textboxes["mem"],
    iconboxes["battery_charge"],
    iconboxes["battery"],
    textboxes["battery"],
    iconboxes["disk_usage"],
    textboxes["disk_usage"],
    iconboxes["uptime"],
    textboxes["uptime"],
}) do
    userdata_layout:add(i)
end
wiboxes["userdata"]:set_widget(userdata_layout)


-- Bottom wibox
bl_width = screen[1].geometry.width*5/6
br_width = screen[1].geometry.width - bl_width
--[[
wiboxes["bottom_left"] = awful.wibox (
    {
        position = "bottom",
        name = "left_statusbar",
        bg = beautiful.bg_normal
    }
)

wiboxes["bottom_left"].widgets = {
    {
        iconboxes["mount1"],
        iconboxes["mount2"],
        iconboxes["mount3"],
        layout = wibox.layout.align.horizontal,
    },
    mylauncher,
    space,
    iconboxes["mpd"],
    small_space,
    media_launcher["media_prev"],
    small_space,
    media_launcher["media_play"],
    small_space,
    media_launcher["media_stop"],
    small_space,
    media_launcher["media_pause"],
    small_space,
    media_launcher["media_next"],
    space,
    textboxes["mpd"],
    layout = wibox.layout.align.horizontal
}
]]

--[[
wiboxes["bottom_right"] = awful.wibox({
    position = "top",
    x = bl_width,
    width = br_width,
    height=20,
    bg="#6E6D63"
})
auto_hide_wibox = {}

for _,wib in ipairs({"bottom_right"}) do
    auto_hide_wibox[wib] = wiboxes[wib]:geometry()
    wiboxes[wib]:geometry({["height"]=2})
    wiboxes[wib]:connect_signal("mouse::enter",function(c)
        wiboxes[wib]:geometry(auto_hide_wibox[wib])
    end)
    wiboxes[wib]:connect_signal("mouse::leave",function(c)
        wiboxes[wib]:geometry({["height"]=1})
    end)
end

wiboxes["bottom_right"].widgets = {
    launchers["Chromium"],
    layout = wibox.layout.align.horizontal,
}
]]

-- Hidden, bottom
wiboxes["bottom_hidden"] = awful.wibox({
    position="bottom",
    bg="#000000",
})
wiboxes["bottom_hidden"].visible=false
wiboxes["bottom_hidden"].widgets = {
    mypromptbox
}

wiboxes["left"] = awful.wibox({
    position="left",
    width=20,
    bg = "#000000"
})

local rot_layout = wibox.layout.rotate()
rot_layout:set_direction("east")
rot_layout:set_widget(mytasklist)
wiboxes["left"]:set_widget(rot_layout)

