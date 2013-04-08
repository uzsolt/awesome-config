tag_list = {
    term =
        { name = "term",    hotkey = "x",   layout = awful.layout.suit.tile,        comment="Terminal", 
            icon = DIRS["home"] .. "/icons/terminal.png" },
    web = 
        { name = "web",     hotkey = "w",   layout = awful.layout.suit.max,         comment="Web browser",
            icon = DIRS["home"] .. "/icons/firefox.png"
        },
    rss =
        { name = "rss",     hotkey = "r",   layout = awful.layout.suit.max,         comment="RSS reader", 
            icon="/usr/share/icons/AwOken/clear/128x128/apps/rss.png" },
    music = 
        { name = "music",   hotkey = "m",   layout = awful.layout.suit.max,         comment="Music player", 
            icon= DIRS["home"] .. "/icons/music-guitar.png"},
    torrent =
        { name = "torrent", hotkey = "t",   layout = awful.layout.suit.tile,        comment="Torrent client", 
            icon= DIRS["home"] .. "/icons/torrent.png"   },
    utils =
        { name = "utils",   hotkey = "u",   layout = awful.layout.suit.tile,        comment="Other utilities", 
            icon= DIRS["home"] .. "/icons/tools.png"  },
    burn = 
        { name = "burn",    hotkey = "n",   layout = awful.layout.suit.max,         comment="Burning", 
            icon= DIRS["home"] .. "/icons/dvd-burn.png"  },
    graphics = 
        { name = "graphics",hotkey = "g",   layout = awful.layout.suit.float,        comment="Graphics utilities", 
            icon="/usr/share/icons/AwOken/clear/128x128/categories/package_graphics.png"},
    games = 
        { name = "games",   hotkey = "s",   layout = awful.layout.suit.max,         comment="Games", 
            icon=icondir .. "categories/package_games.png"},
    dox = 
        { name = "dox",     hotkey = "d",   layout = awful.layout.suit.tile.left,   comment="LaTeX, OpenOffice", 
            icon= DIRS["home"] .. "/icons/dox.png",mwfact=0.5},
    libreoffice =
        { name= "libreoffice", hotkey="c", layout = awful.layout.suit.tile.right,   comment="LibreOffice suites", 
            icon= DIRS["home"] .. "/icons/libreoffice.png" },
    devel = 
        { name = "devel",     hotkey = "v",   layout = awful.layout.suit.max,        comment="Program developing", 
            icon= DIRS["home"] .. "/icons/geek-zombie-icon.png"         },
    pld =
        { name = "pld",     hotkey = "l",   layout = awful.layout.suit.magnifier,   comment="PLD developing", icon="hacker-mini.png"},
    arch =
        { name = "arch",    hotkey = "a",   layout = awful.layout.suit.tile.right,         comment="Arch developing", 
            icon= DIRS["home"] .. "/icons/arch.png"},
    pdf = 
        { name = "pdf",     hotkey = "f",   layout = awful.layout.suit.max,         comment = "PDF documents", 
            icon= "/usr/share/icons/AwOkenWhite/clear/128x128/mimetypes/pdf.png"},
    wine = 
        { name = "wine",    hotkey = "i",   layout = awful.layout.suit.float,       comment = "Wine applications", 
            icon=icondir .. "apps/wine.png" },
}

tags = {}
for i,xtag in pairs(tag_list) do
    tags[i] = awful.tag.add(xtag.name,{
        icon_only   =   true,
        layout      =   xtag.layout,
        icon        =   xtag.icon
    })
end

function get_tag_by_name(des_tag)
    return tags[des_tag]
end

--[[
tags_by_name = {}
for i = 1,#tag_list do
    tags[tag_list[i].name] = tags[i]
end

function get_tag_by_name(des_tag)
    local i
    for i = 1,#tag_list do
        if tag_list[i].name == des_tag then return i
        end
    end
    return -1
end

function get_tag_struct(des_tag)
    return tags[get_tag_by_name(des_tag)]
end
]]
tags["term"].selected = true




