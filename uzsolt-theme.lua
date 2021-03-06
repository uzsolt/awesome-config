theme = {
    font          = "sans 8",

    bg_normal     = "#0022aa88",
    bg_focus      = "#287d0088",
    bg_urgent     = "#ff0000",
    bg_minimize   = "#0067ce",
    fg_normal     = "#aaaaaa",

	fg_focus      = "#ffffff",
	fg_urgent     = "#ffffff",

	border_width  = 2,
	border_normal = "#ff0000",
	border_focus  = "#00ff00",
	border_marked = "#91231c",

	menu_fg_normal = "#000000",
	menu_bg_normal = "#80827F",
	menu_bg_focus = "#ff0000",

    titlebar_bg_focus = "#000000aa",
    titlebar_bg_normal = "#222222",

    tooltip_bg_color = "#000000bb",

    taglist_bg_focus = "#55555599",

	tasklist_floating_icon = DIRS["theme"]["tasklist"] .. "floatingw.png",

    tasklist_bg_normal = "#00330000",
    tasklist_bg_focus  = "#003300ff",

    titlebar_close_button_normal = "/usr/share/icons/AwOkenWhite/clear/24x24/apps/wincloser16.png",
    titlebar_close_button_focus ="/usr/share/icons/AwOkenWhite/clear/24x24/apps/wincloser16.png", 

	menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png",
	menu_height   = "20",
	menu_width    = "200",

    tooltip_bg_color = "#222222",
    tooltip_fg_color = "#aaaaaa",
    tooltip_font     = "terminus 8",
    tooltip_border_width = 1,
    tooltip_border_color = "#557755",


	awesome_icon           = "/usr/share/awesome/themes/sky/awesome-icon.png",
    wallpaper = "/home/users/zsolt/kepek/kismano/2012-08-09-montenegro-denovici/DSCF3941.JPG"

}

function theme_buttons() 
    local i
    local j
    for _,i in pairs({"ontop","sticky","floating","maximized"}) do
        for _,j in pairs({"normal","focus"}) do
            for _,k in pairs({"active","inactive"}) do
                theme["titlebar_" .. i .. "_button_" .. j .. "_" .. k] =
                    DIRS["theme"]["titlebar"] .. i .. "_" .. j .. "_" .. k .. ".png"
            end
        end
    end
end

function theme_layouts()
    local i
    for _,i in pairs({"fairh","fairv","floating","magnifier","max","fullscreen","tilebottom","tileleft","tile","tiletop"}) do
        theme["layout_" .. i] = DIRS["theme"]["layouts"] .. i .. ".png"
    end
end

theme_buttons()
theme_layouts()

theme.wallpaper_cmd = { "feh --bg-fill " .. theme.wallpaper }
--theme.wallpaper_cmd = { "awsetbg /usr/share/awesome/themes/zenburn/zenburn-background.png" }

return theme

