
-- Hook function to execute when marking a client
function hook_marked(c)
    c.border_color = beautiful.border_marked
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c.border_color = beautiful.border_focus
end

function wibox_left_toggle()
    local current_tag = awful.tag.selected()
    if (#(current_tag:clients()) > 0) then
        wiboxes["left"].visible = true
    else
        wiboxes["left"].visible = false
    end
end

-- Hook function to execute when a new client appears.
client.connect_signal("manage",function (c,startup)

    wibox_left_toggle()
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

end)

client.connect_signal("unmanage", function(c)
    wibox_left_toggle()
end)

client.connect_signal("focus",function(c)
    c.opacity = 1
    wibox_left_toggle()
end)

client.connect_signal("unfocus",function(c)
    c.opacity = 0.8
    wibox_left_toggle()
end)

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    local layout = awful.layout.getname(awful.layout.get(screen))

    if layout then
            mylayoutbox:set_image(image("/usr/share/awesome/themes/default/layouts/" .. layout .. "w.png"))
    end

    -- If no window has focus, give focus to the latest in history
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    local sel = client.focus
    if sel then
        local c_c = sel:coords()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end

