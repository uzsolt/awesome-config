clientbuttons = awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey }, "m", function (c)
	c.maximized_horizontal = not c.maximized_horizontal
	c.maximized_vertical = not c.maximized_vertical
    end),
    awful.key({ modkey, "Shift" }, "c", function () client.focus:kill() end),
    awful.key({ modkey }, "i", function(c)
        local prop, txt
        txt = ""
        for _,prop in ipairs({"class","instance","name","role"}) do
            txt = txt .. (txt=="" and "" or "\n") .. prop .. " > " .. (c[prop] or "[[ none ]]")
        end
        naughty.notify({text=txt,timeout=5})
    end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function () client.focus:swap(awful.client.master()) end),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, "Shift" }, "r", function () client.focus:redraw() end),
    awful.key({ modkey, "Control" }, "t", function () 
        client.focus.ontop = not client.focus.ontop 
        client.focus.skip_taskbar = client.focus.ontop
        client.focus.focusable = not client.focus.ontop
        if client.focus.ontop then
            client.focus.opacity = 0.7
        else
            client.focus.opacity = 1
        end
    end)
)

awful.rules.rules = {
    { rule={},
        properties={
            focus = true,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = true,
        },
    },
    { -- Title bar
        rule_any = {
            class = {
                "Vlc"
            }
        },
        callback = function(c)
            -- Widgets that are aligned to the left
            local left_layout = wibox.layout.fixed.horizontal()
            left_layout:add(awful.titlebar.widget.iconwidget(c))

            -- Widgets that are aligned to the right
            local right_layout = wibox.layout.fixed.horizontal()
            --right_layout:add(awful.titlebar.widget.floatingbutton(c))
            right_layout:add(awful.titlebar.widget.maximizedbutton(c))
            --right_layout:add(awful.titlebar.widget.stickybutton(c))
            --right_layout:add(awful.titlebar.widget.ontopbutton(c))
            right_layout:add(awful.titlebar.widget.closebutton(c))

            -- The title goes in the middle
            local title = awful.titlebar.widget.titlewidget(c)
            title:buttons(awful.util.table.join(
                    awful.button({ }, 1, function()
                        client.focus = c
                        c:raise()
                        awful.mouse.client.move(c)
                    end),
                    awful.button({ }, 3, function()
                        client.focus = c
                        c:raise()
                        awful.mouse.client.resize(c)
                    end)
                    ))

            -- Now bring it all together
            local layout = wibox.layout.align.horizontal()
            layout:set_left(left_layout)
            layout:set_right(right_layout)
            layout:set_middle(title)

            awful.titlebar(c):set_widget(layout)
        end
    },
    {
        rule_any = {
            class = {
                "feh",
                "Vlc",
                "Mplayer",
            },
        },
        properties = {
            floating = true
        },
    },
    {
        rule_any = {
            class = {
                "Chromium",
                "Firefox",
                "luakit"
            },
            name = {
                "Névtelen - Chromium"
            },
        },
        except_any = {
            name = {"Developer Tools.*"}
        },
        properties = { tag = tags["web"] }
    },
    {
        rule = {
            instance = "Abp"
        },
        properties = {
            floating = true
        }
    },
    {
        rule = {
            class = "Firefox",
            instance = "Dialog"
        },

    },
    {
        rule_any = {
            class = {
                "libreoffice-calc",
                "libreoffice-writer",
                "LibreOffice",
            },
            name = {
                "LibreOffice"
            }
        },
        properties = { tag = tags["libreoffice"] }
    },
    {
        rule_any = {
            class = {
                "Cdcat",
                "Fet",
                "Grisbi"
            },
        },
        properties = { tag = tags["utils"] }
    },
    {
        rule_any = { class = {
            "Evince",
            "Xpdf",
            "Zathura",
            "Acroread",
        }},
        except = { instance = "latex-viewer" },
        properties = { tag = tags["pdf"] }
    },
    {
        rule = { instance = "latex-viewer" },
        properties = { tag = tags["dox"] }
    },
    {
        rule_any = { class = {
            "Qmpdclient",
        }},
        properties = { tag = tags["music"] }
    },
    {
        rule_any = { class = {
            "Wine",
        }},
        properties = {
            tag = tags["wine"],
            switchtotag = true
        }
    },
    {
        rule_any = {
            class = {
                "Xsane",
                "Gimp-2.8",
                "Gliv",
                "Gwenview",
                "geogebra-GeoGebra",
                "GeoGebra",
            },
        },
        properties = { tag = tags["graphics"] }
    },
    {
        rule = { class = "Speedcrunch" },
        properties = { 
            x = 433,
            y = 234,
            width = 500,
            height = 300,
            floating = true,
        }
    }
}

local urxvt_rules = {
    ArchLinux   = "arch",
    devel       = "devel",
    RSS         = "rss", 
    dox         = "dox",
    torrent     = "torrent",
    urxvt       = "term",
    PLD         = "pld",
    BashBurn    = "burn"
}

for inst,target in pairs(urxvt_rules) do
    table.insert(awful.rules.rules,{
        rule = {
            class = "URxvt",
            instance = inst
        },
        properties = { tag = tags[target] }
    })
end

