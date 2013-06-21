
icondir = "/usr/share/icons/AwOken/clear/128x128/"

emails = {}

function printdate(msg)
    local format = "%H:%M:%S"
    print("\t" .. msg .. ": " .. os.date(format))
    io.flush()
end

function msg_begin()
        printdate("Begin")
end

function msg_end()
        printdate("End")
end

--[[myrequire("awful.autofocus")
myrequire("awful.rules")
myrequire("awful.remote")
]]
mylocale = "hu_HU.UTF-8"
os.setlocale(mylocale)
lgi       = require("lgi")
gears     = require("gears")
awful     = require("awful")
awful.rules     = require("awful.rules")
            require("awful.autofocus")
beautiful = require("beautiful")
naughty   = require("naughty")
vicious   = require("vicious")
menubar   = require("menubar")
wibox     = require("wibox")


if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Awesome hiba!",
        text = awesome.startup_errors
    })
end

colorbars = {
    "#ff0000",
    "#ff00ff",
    "#15ecfb",
    "#aaaaaa"
    --"#fa7e1a"
}


    --[[
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
    ]]


menubar.cache_entries=true
--menubar.set_icon_theme("/usr/share/icons/AwOken/clear/")
menubar.menu_gen.all_menu_dirs = {
    "/usr/share/applications/",
    "/home/users/zsolt/awesome-resources/applications/"
}
--[[menubar.g.width=1300
menubar.g.x = 0
menubar.g.y = 720
]]

local menubar_change = {
    multimedia = "Média",
    Development = "Fejlesztés",
    Education = "Oktatás",
    Game = "Játékok",
    Graphics = "Grafika",
    Office = "Iroda",
    Network = "Hálózat",
    Settings = "Beállítások",
    System = "Rendszer",
    Utility = "Eszközök",
    Education = "Oktatás",
}

for i,j in pairs(menubar.menu_gen.all_categories) do
    menubar.menu_gen.all_categories[i].name = 
        menubar_change[j.app_type] or j.name
    menubar.menu_gen.all_categories[i].use = true
end

DIRS = {}

DIRS["home"]        = os.getenv("HOME") .. "/"
DIRS["res"]         = DIRS["home"] .. "awesome-resources/"
DIRS["icons"]       = DIRS["res"] .. "icons/"
DIRS["config"]      = DIRS["home"] .. ".config/awesome/"
DIRS["termit"]      = DIRS["home"] .. ".config/termit/"
DIRS["lilyterm"]    = DIRS["home"] .. ".config/lilyterm/"
DIRS["log"]         = DIRS["home"] .. "tmp/"

DIRS["theme"]       = {}
DIRS["theme"]["main"] = "/usr/share/awesome/themes/default/"
for _,dir in pairs({"taglist","tasklist","titlebar","layouts"}) do
    DIRS["theme"][dir] = DIRS["theme"]["main"] .. dir .. "/"
end
DIRS["theme"]["layouts"] = "/usr/share/awesome/themes/zenburn/layouts/"

DIRS["term"] = {}
DIRS["term"]["dox"]     = DIRS["home"] .. "Dokumentumok/"
DIRS["term"]["progs"]   = DIRS["home"] .. "progs/"
DIRS["term"]["grav"]     = DIRS["home"] .. "u-szeged/phd/"


dofile(DIRS["config"] .. "/functions.lua")

print("Theme information")
msg_begin()
beautiful.init(CreateFullPath("config","uzsolt-theme.lua"))
gears.wallpaper.maximized(beautiful.wallpaper)
msg_end()


modkey = "Mod1"
winkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
     awful.layout.suit.tile,
     awful.layout.suit.tile.left,
     awful.layout.suit.tile.bottom,
     awful.layout.suit.tile.top,
     awful.layout.suit.fair,
     awful.layout.suit.fair.horizontal,
     awful.layout.suit.max,
     awful.layout.suit.max.fullscreen,
     awful.layout.suit.magnifier,
     awful.layout.suit.floating
}

layout_names = {}
for i = 1,#layouts do
    layout_names[awful.layout.getname(layouts[i])] = layouts[i]
end

image_not_mounted = "Folder-Unavailable-Folder-icon.png"
ownfiles = { 
    "background",
    "tags",
    "hooks",
    "keybindings",
    "blinking",
    "client_rules-auto",
    "widgets",
    "wiboxes",
    --"uzsolt-mpd",
    "timers",
    "vicious-widgets",
    "mpdcron",
}

for _,i in ipairs(ownfiles) do
    print(i)
    msg_begin()
    dopath(i .. ".lua")
    msg_end()
end

print("Ownfiles end")
io.flush()

