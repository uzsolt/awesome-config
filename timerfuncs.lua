
fs_usage_table = {}
update_packs = {}
emails = {}
unread_rss = 0

function check_alert() 
    local dir
    if (#emails+#update_packs+unread_rss>0) then
        dir = "AwOkenWhite"
    else
        dir = "AwOken"
    end
    iconboxes["top"]:set_image(ib_Image(
        "/usr/share/icons/" .. dir .. "/clear/24x24/apps/htop.png"
    ))
end

function hook_network ()
    local nw_file = io.open(CreateFullPath("log","network-log"))
    local str
    if nw_file then
        str = nw_file:read("*line")
        nw_file:close()
        if str then
            if (str == "modem") or (str == "router") then
            else
            end
        end
    end
end

function hook_euro ()
    local euro_file = io.open(CreateFullPath("log","euro"))
    if euro_file then
        local str = euro_file:read("*line")
        -- gsub(str,",",".")
        if str then
            local x = tonumber(str)
            local out = ' <span color="'
            if x>285 then
                out = out .. "red"
            elseif x>280 then
                out = out .. "yellow"
            elseif x>275 then
                out = out .. "green"
            else
                out = out .. "#00FFCC"
            end
            textboxes["euro"].text = out .. '">' .. str .. " Ft</span>" 
        end
        euro_file:close()
    end
end

function arch_readfile()
    local f = io.open(DIRS["home"] .. "/logfiles/pacman.update")
    update_packs = {}
    s = f:read("*line")
    while s do
        if (s~="") then
            table.insert(update_packs,s)
        end
        s = f:read("*line")
    end
    f:close()
end

function hook_arch_update() 
    arch_readfile()
    textboxes["arch"]:set_markup( "<span color='lightblue'>Frissítések:</span> " .. 
        "<span color='lightgreen'>" ..  #update_packs .. "</span>")
    check_alert()
end


require("etree")

function hook_gmail()
    local xfile = io.open("/home/users/zsolt/logfiles/gmail-unread")
    emails = {}
    if (xfile==nil) then
        textboxes["gmail"]:set_markup("err")
        return
    end
    local str = xfile:read("*all")
    xfile:close()

    xmlt = etree.fromstring(str)
    if xmlt == nil then
        textboxes["gmail"]:set_markup("0")
        return
    end

    for i=1,#xmlt do
        if (xmlt[i].tag or "") == "entry" then
            local one_item = {}
            for k,l in pairs(xmlt[i]) do
                if ( ( l.tag or "" ) == "title" ) or
                    ( ( l.tag or "") == "summary" ) then
                    one_item[l.tag] = l[1]
                elseif (l.tag or "") == "author" then
                    -- in gmail: inside 'author': 'name' and 'email'
                    one_item["name"] = l[2][1]
                end
            end
            table.insert(emails,one_item)
        end
    end
    textboxes["gmail"]:set_markup(#emails)
    check_alert()
end

function fs_usage(ret)
    local f = io.popen("LC_ALL=C /bin/df -m")
    -- skip the first line
    f:read("*line")
    ret = ret or {}

    s = f:read("*line")
    while s do
        local _,_,mp = string.find(s,".*%%%s*(.+)")
        ret[mp] = ret[mp] or {}
        _,_, ret[mp].dev,
            ret[mp].size,
            ret[mp].used,
            ret[mp].avail,
            ret[mp].perc = string.find(s,"(%S+)%D*(%d+)%D*(%d+)%D*(%d+)%D*(%d+)%%")
        s = f:read("*line")
    end

    f:close()
end

function hook_rss()
    local f = io.open("/home/users/zsolt/logfiles/newsbeuter-unread-items")
    local s = f:read("*line") or 0
    f:close()
    unread_rss = s
    textboxes["rss"]:set_markup(coloring(s,"#00ff00"))
    check_alert()
end

mount_points = { "/","/home","/home/downloads","/var",--[["/home/irando",]]"/backup"}
short_mount_points = {}

for i=1,#mount_points do
    if mount_points[i]=="/" then
        short_mount_points[i] = "root"
    else
        _,_,short_mount_points[i] = string.find(mount_points[i],".*/(.*)")
    end
end

function rounding(x,n)
    np = n or 1
    return math.ceil(x*10^np)/10^np
end

blinking_on = 0

function hook_fs_usage()
    local mycolor,fsperc

    local sep = "<span color='#000000'>&lt;&gt;</span>"
    local txt = sep
    for fs_usage_counter=1,#mount_points do
        fsperc = tonumber(fs_usage_table[mount_points[fs_usage_counter]].perc)
        if fsperc>90 then
            mycolor = "red"
        elseif fsperc>85 then
            mycolor = "yellow"
        elseif fsperc>80 then
            mycolor = "lightgreen"
        else
            mycolor = "grey"
        end

        txt = txt .. "<span color='lightblue'>" .. short_mount_points[fs_usage_counter] .. "</span> " .. 
            "<span color='" .. mycolor .. "'>" ..
            rounding(fs_usage_table[mount_points[fs_usage_counter]].avail/1024,1) .. "/" .. 
            rounding(fs_usage_table[mount_points[fs_usage_counter]].size/1024,1) .. " (" ..
            100-fs_usage_table[mount_points[fs_usage_counter]].perc .. "%)" ..
            "</span>" .. sep
    end
    textboxes["disk_usage"]:set_markup(txt)
end

function hook_get_fs_usage()
    fs_usage(fs_usage_table)
end

function get_launchers_table()
    tmp_launchers = awful.util.table.clone(launchers)
    local clients = client.get(0)
    for _,client in pairs(clients) do
        if (launchers[client.class]~=nil) then
            tmp_launchers[client.class] = nil
        end
    end
    local ret = {}
    local x,y
    for x,y in pairs(tmp_launchers) do
        if (y~=nil) then
            table.insert(ret,x)
        end
    end
    return ret
end

launchers_to_wibox = {}

function in_table(table,what)
    local item
    for _,item in pairs(table) do
        if (what==item) then
            return true
        end
    end
    return false
end

function table_equal(t1,t2)
    if (t1==nil) then
        return false
    end
    if ( #t1 ~= #t2 ) then
        return false
    end
    local item
    for _,item in pairs(t1) do
        if (not in_table(t2,item)) then
            return false
        end
    end
    return true
end

--[[
function set_wibox_widgets()
    local tmp = get_launchers_table()
    if (table_equal(tmp,launchers_to_wibox)) then
        return
    end

    wiboxes["bottom_right"].widgets = {}
    local x
    local nr = 0
    for _,x in pairs(tmp) do
        nr = nr+1
        wiboxes["bottom_right"].widgets[nr] = launchers[x]
    end
    wiboxes["bottom_right"].widgets.layout = awful.widget.layout.horizontal.rightleft
    launchers_to_wibox = tmp
end
]]

function hook_change_to_web()
    local clients = client.get(0)
    local client
    for _,client in pairs(clients) do
        if (client["class"]=="Chromium") then
            if string.find(client["name"],"Share on Tumblr") then
                awful.tag.viewonly(tags["web"])
            end
        end
    end
end

