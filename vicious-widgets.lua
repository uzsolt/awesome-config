vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.net)

-- uptime
vicious.register(textboxes["uptime"],vicious.widgets.uptime,
    function (widget,args)
        local mainstr = '<span color="lightblue"> Uptime: </span><span color="white">'
        formatstr = string.format( '%d:%02d</span>',args[2],args[3] )
        if (args[1]>0) then
            formatstr = string.format('<span color="green">%d nap</span> ',args[1]) .. formatstr
        end
        return mainstr .. formatstr
    end, 20)

function load_color(val)
    os.setlocale("C")
    local color="#aaaaaa"
    val = tonumber(val)
    if (val>3) then 
        color = "#ff0000"
    elseif (val>2.8) then
        color = "#ccff00"
    elseif (val>2) then
        color = "#ff9900"
    elseif (val>1.4) then
        color = "#00cc00"
    else
        color = "#555555"
    end
    val = string.format("%.2f",val)
    os.setlocale(mylocale)
    return "<span color='" .. color .. "'>" .. awful.util.escape(val) .. "</span>"
end

vicious.register(textboxes["load"],vicious.widgets.uptime,function(widget,args)
    str = load_color(args[4]) .. " " .. load_color(args[5]) .. " " .. load_color(args[6])
    return str
end,5)

-- network
--[[
possible_interfaces = { "eth0", "wlan0" }
active_interface = ""
local tmp_file = io.popen('ps -o args= -C dhcpcd')
if tmp_file then
    local tmp_str,i
    tmp_str = tmp_file:read("*line")
    while (tmp_str and active_interface=="") do
        if (tmp_str) and (tmp_str ~= "") then
            for i=1,#possible_interfaces do
                if string.find(tmp_str,possible_interfaces[i]) then
                    active_interface = possible_interfaces[i]
                end
            end
        end
        tmp_str = tmp_file:read("*line")
    end
    tmp_file:close()
--]]
active_interface="wlan0"

    if (active_interface and active_interface ~="") then
        vicious.register(textboxes["net_down"],vicious.widgets.net, 
            function (widget,args)
                local down = math.floor(args["{wlan0 down_kb}"])
                local color = get_color_by_value(down,
                    {1000,500,300}
                )
                local unit="k"
                if (down>=1000) then
                    down = math.floor(down/1024*10)/10
                    unit="M"
                end
                return "<span color='" .. color .. "'>" ..
                    down .. unit .. "</span>"
            end,1)
        vicious.register(graphs["net_down"], vicious.widgets.net, 
            function (widget,args)
                return 100*args["{wlan0 down_kb}"]
            end,1)
        vicious.register(textboxes["net_up"], vicious.widgets.net, 
            function(widget,args)
                local up = math.floor(args['{' .. active_interface ..' up_kb}'])
                local color=get_color_by_value(up,{55,40,30})
                return "<span color='" .. color .. "'>" .. args['{' .. active_interface ..' up_kb}'] .. "</span>"
            end, 1)
        vicious.register(graphs["net_up"], vicious.widgets.net, function (widget,args)
            return 100*math.floor(args["{wlan0 up_kb}"])
        end,1)
        if (active_interface == "wlan0") then
            vicious.register(textboxes["wlan"],vicious.widgets.wifi,function (widget, args)
                local link_percent = math.floor(args["{link}"]/70*100)
                local img_percent = (math.floor((math.min(link_percent+25,100)/25)))*25
                --iconboxes["network"]:set_image("/usr/share/icons/AwOkenWhite/clear/128x128/apps/wifi-" .. string.format("%.3d",img_percent) .. ".png")
                iconboxes["network"]:set_image(DIRS["home"] .. "/icons/wifi/" .. string.format("%.3d",img_percent) .. ".png")
                --GetImage("widgets/Devices-network-wireless-connected-" ..  img_percent .. "-icon.png")
                return "<span color='lightgreen'>" .. args["{ssid}"] .. "</span> <span color='#666666'>(" .. link_percent .. "%)</span>"
            end,5,"wlan0")
        else
            textboxes["wlan"].text = active_interface
        end
    else
        textboxes["wlan"].text = "<span background='red' color='black'>no network</span>"
    end
--end


-- CPU
for i=1,3 do
    vicious.register(graphs["cpu" .. i], vicious.widgets.cpu, '$'..i,1)
    vicious.register(textboxes["cpu" .. i], vicious.widgets.cpu, function (widget,args)
        result = '<span color="' ..
            get_color_minmax(args[i],0,100) ..
            --get_color_by_value(args[i],{70,40,10}) ..
            '">' ..
            args[i] .. '%' .. '</span>'
        return result
    end,1)
end

for i=0,1 do
    vicious.register(textboxes["cpu" .. i .. "_freq"],vicious.widgets.cpuinf, function(widget,args)
        cpughz = args['{cpu' .. i ..' ghz}']
        color = (cpughz>2) and "lightgreen" or "yellow"
        return '<span color="' .. color .. '"> ' .. string.format("%.2f",cpughz) .. ' GHz</span>'
    end,5)
end

-- swap and memory
vicious.register(textboxes["mem"],vicious.widgets.mem,'$1%',5)

--[[
vicious.register(textboxes["mpd"],vicious.widgets.mpd,
    function (widget,args)
        if args["{state}"] == "Stop" then return "Stopped." else
            return args["{Artist}"] .. " - " .. args["{Title}"]
        end
    end,1
)
]]

blinking_battery = 0
vicious.register(textboxes["battery"],vicious.widgets.bat, function (widget, args)
    local f = io.open("/sys/class/power_supply/AC0/online")
    local img_path = DIRS["icons"] .. "/fb-battery/"
    local color = "grey"

    if f~=nil then
        s = f:read("*line")
        f:close()
    else
        s = ""
    end

    local charge = DIRS["home"] .. "/icons/battery/battery_"
    if string.find(s,"1") then
        charge = charge .. "power"
        color="grey"
    else
        charge = charge .. "empty"
    end
    iconboxes["battery_charge"]:set_image(charge .. ".png")

    img_path = DIRS["home"] .. "/icons/battery/battery_" .. math.floor(args[2]/12) .. ".png"
    if (args[2]<20) and (infix=="") then
        blinking(textboxes["battery"])
    else
        if (blinking_battery>0) then
            blinking(textboxes["battery"])
            blinking_battery=0
        end
    end
    iconboxes["battery"]:set_image(img_path)
    return "<span color='" .. color .."'>" .. args[2] .. '%' .. "</span>"
end, 10,'BAT0')

--[[
vicious.register(tb_du_torrent,vicious.widgets.fs, function (widget, args)
    print(#args)
    local free = tonumber(args["{/home/ avail_gb}"]) or 0.2

    return "<span color='" ..
        ( 
            (free<1) and "red" or
            (free<2) and "yellow" or
            (free<4) and "lightblue" or "green"
        ) .. "'>" ..  args["{/ avail_gb}"] .. "G</span>"
end,60)
]]

