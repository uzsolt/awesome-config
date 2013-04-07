function get_ps_filter(cmd) 
    return "grep \"[0-9]*:[0-9]* " .. cmd .."\""
end

-- egy adott program fut-e vagy se
function is_run(cmd)
    local f = io.popen('ps aux | ' .. get_ps_filter(cmd))
    local ret = false
    for i in f:lines() do
        ret = true
    end
    return ret
end

-- msg színezése color színre
function coloring(msg,color)
    return "<span color='" .. color .. "'>" .. (msg or "") .. "</span>"
end

-- teljes elérési út generálása
-- A dir a DIRS tömb egy eleme
function CreateFullPath(dir,file)
    return (DIRS[dir] or "./") .. (file or "")
end

-- Kép visszaadása, icons/imagename
function GetImage(imagename)
    return (CreateFullPath("icons",imagename))
end

-- Az awesome konfig-könyvtárából egy fájl beillesztése
function dopath(file)
    dofile(DIRS["config"] .. file)
end

local color_min = 0x00ff00
local color_max = 0xff0000
function get_color_minmax(val,min,max,prt)
    local r_min = (math.floor(color_min/0xffff))
    local r_max = (math.floor(color_max/0xffff))
    local g_min = (math.floor( (color_min-r_min*0xffff)/0xff ))
    local g_max = (math.floor( (color_max-r_max*0xffff)/0xff ))
    local b_min = color_min - r_min*0xffff - g_min*0xff
    local b_max = color_max - r_max*0xffff - g_max*0xff

    local str = string.format("#%.2x%.2x%.2x",
        math.min(0xff,math.floor( (val-min)/(max-min)*r_max + (max-val)/(max-min)*r_min )),
        math.min(0xff,math.floor( (val-min)/(max-min)*g_max + (max-val)/(max-min)*g_min )),
        math.min(0xff,math.floor( (val-min)/(max-min)*b_max + (max-val)/(max-min)*b_min ))
    )
    return str
end

function get_color_by_value(val,limits)
    val = math.floor(val)
    local i=1;
    while (i<#colorbars) do
        if (val>limits[i]) then
            return colorbars[i]
        end
        i=i+1
    end
    return colorbars[i]
end

