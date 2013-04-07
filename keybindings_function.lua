function urxvt_options(fn,command)
    local f = io.open(fn,"r")
    if (not f) then
        return
    end

    local params = ""
    local options = {
        ["background"]  =   "-pixmap",
        ["title"]       =   "-title",
        ["scrollbar"]   =   {
            ["true"]    =   "-sb",
            ["false"]   =   "+sb"
        },
        ["transparent"] =   {
            ["true"]    =   "-tr",
            ["false"]   =   "+tr"
        },
        ["opacity"]     =   "-sh",
        ["name"]        =   "-name",
        ["dir"]         =   "-cd",
        ["font"]        =   "-fn",
        ["fontcolor"]   =   "-fg"
    }
    local cjson = require "cjson"
    local opt = cjson.decode(f:read("*all")) f:close()
    local i,j
    for i,j in pairs(opt) do
        if (options[i]) then
            if (type(options[i])=="table") then
                params = params .. (options[i][j] or "") .. " "
            else
                params = params .. options[i] .. " \"" .. j .. "\" "
            end
        end
    end
    command = command or "tmux -2"
    awful.util.spawn("urxvt " .. params .. " -e " .. command)
end

-- infos

notify_info = nil
function info_general(icon,title,str)
    naughty.destroy(notify_info)

    naughty_info = naughty.notify({
        icon = DIRS["icons"] .. "/" .. icon,
        title = title,
        bg = "#002233",
        text = str
    })
end

function info_mail()
    local ret
    if (#emails==0) then
        ret = "Nincs olvasatlan levél."
    else
        ret = ""
        for _,j in pairs(emails) do
            ret = ret ..
                coloring(awful.util.escape(j["name"]),"#ff0000") .. "\n\t" .. 
                coloring(awful.util.escape(j["title"]),"#00ff00") .. "\n\t" ..
                coloring(awful.util.escape(j["summary"]),"#999999") .. "\n"
        end
    end
    info_general("widgets/gmail-62.png","Olvasatlan levelek",ret)
end

function info_mpd()
    local f = io.popen("mpc status")
    info_general("widgets/rock_tux.png","MPD info",f:read("*all"))
end
    
function info_rss()
    local maximum_per_node = 3
    local f = io.open(DIRS["home"] .. "/logfiles/newsbeuter-unread-items")
    -- skip the first line
    local line = f:read("*line")
    local ret = ""
    if (line=="0") then
        ret = awful.util.escape(" [[ Nincs olvasatlan hír ]]")
    else
        local line = f:read("*line")
        while (line~=nil) do
            local i,j = line:find("|")
            local tag = line:sub(1,j-1)
            ret = ( (ret=="") and "" or (ret .. "\n") ) ..
                coloring(awful.util.escape( " << " .. tag .. " >>"),"#ff00aa")
            line = line:sub(j+1,-1)
            local item_number = 0
            while (line~="") do
                local ii,ij = line:find("@")
                ij = ij and ij or 0
                ret = ret .. "\n\t" .. 
                    coloring(awful.util.escape(line:sub(1,ij-1)),"#ffffff")
                line = (ij==0) and "" or line:sub( ij+1,-1)
                item_number = item_number + 1
                if (item_number==maximum_per_node) then
                    if (line~="") then
                        line = ""
                        ret = ret .. "\n\t [ ... ]"
                    end
                end
            end
            line = f:read("*line")
        end
        f:close()
    end
    info_general("widgets/tux_rss.png","Olvasatlan hírek",ret)
end

function info_torrent()
    local f = io.popen(DIRS["home"] .. "/bin/transmission-active")
    info_general("widgets/tux_torrent-64.png","Torrent",f:read("*all"))
    f:close()
end

function info_packages()
    local ret = ""
    local f = io.open(DIRS["home"] .. "/logfiles/pacman.update")
    s = f:read("*line")
    while (s) do
        ret = ret .. s .. "\n"
        s = f:read("*line")
    end
    if (ret=="") then
        ret=awful.util.escape("<< nincs elérhető frissítés >>")
    end
    f:close()
    info_general("widgets/tux_arch-64.png","Frissítendő csomagok",ret)
    return ret
end

-- chromium

function open_url(url)
    awful.util.spawn("firefox -new-tab \"" .. url .. "\"")
end

-- ****************
--  Awesome menu
-- ****************
function aw_helpers_start()
    wiboxes["bottom_hidden"].visible=true
end

function aw_helpers_end()
    wiboxes["bottom_hidden"].visible=false
end

local aw_notify = nil
function aw_abstract( prompt,func,cachefile )
    aw_helpers_start()
    local val = nil
    awful.prompt.run(
        {
            text=val and tostring(val),
            selectall=true,
            prompt=coloring(prompt .. ": ","#00A5AB"),
        },
        mypromptbox.widget,
        function(expr)
            local ret = func(expr)
            io.popen("echo '" .. ret .. "' | xclip -selection clipboard")
            local rootkeys = root.keys()
            aw_notify = naughty.notify({
                text = expr .. " = " .. coloring(ret,"#BBBBBB"),
                timeout=0,
                position="bottom_left",
                run = function()
                    naughty.destroy(aw_notify)
                    root.keys(rootkeys)
                end
            })
            root.keys(awful.util.table.join(
                rootkeys,
                awful.key({},"Escape",function ()
                    if aw_notify then
                        naughty.destroy(aw_notify)
                    end
                    root.keys(rootkeys)
                end)
            ))
        end,nil,
        awful.util.getdir("cache") .. "/" .. cachefile,100,
        function()
            aw_helpers_end()
        end
    )
end

function aw_calculator()
    local val = nil
    aw_abstract("Calc",
        function(expr)
            local cmd = "echo '" .. expr .. "' | wcalc -r -P10 -q"
            local f = io.popen(cmd)
            if f then
                val = f:read("*line")
                f:close()
            else
                val = "< error >"
            end
            return val
        end,
        "calc"
    )
end

function aw_translate(trans)
    trans = trans or "en hu"
    aw_abstract(
        coloring("Translate " .. coloring("("..string.gsub(trans," "," => ")..")","#BBBBBB") .. ": ",'#00A5AB'),
        function(expr)
            run_background("/usr/bin/google-translate " .. trans .. " '" .. expr .. "'",function(val)
                notify_keychain = naughty.notify({
                    text = expr .. '\n' .. coloring(val,"white"),
                    timeout = 0,
                    position = "bottom_left"
                })
            end)
        end,
        "translate"
    )
end


--[[
--MPD
--]]
function mpd_command(cmd)
    if (not cmd) then
        return
    end
    io.popen("mpc " .. cmd)
end

function client_menu()
    local clients = client.get()
    local i,c
    local menux = {}
    table.sort(clients,
        function(a,b)
            return (a.class==b.class) and (a.name<b.name) or (a.class<b.class)
        end
    )
    local already = {}
    for i,c in ipairs(clients) do
        local tmp = {
            c.name,
            function()
                awful.tag.viewonly(c:tags()[1])
                client.focus=c
            end,
            c.icon
        }
        if (not menux[c.class]) then
            menux[c.class] = tmp
            already[c.class] = 0 
        elseif (already[c.class]==0) then
            local tm = menux[c.class]
            menux[c.class] = {c.class,{tm,tmp},c.icon}
            already[c.class] = 1
        else
            --table.insert(menux[c.class][2],tmp)
        end
    end
    awful.menu(menux):show()
end

