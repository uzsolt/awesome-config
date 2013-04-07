function taskwarrior_line2table(line)
    line = line:sub(2,-2)
    local ret = {}
    while (line~="") do
        i,j, tag,val = line:find("(%a+):\"([^\"]+)\"%s*")
        ret[tag] = awful.util.escape(val)
        line = line:sub(j+1,-1)
    end
    return ret
end

function taskwarrior_parse(file)
    taskwarrior_file = file or "/home/users/zsolt/.task/pending.data"
    local ret = {}
    f = io.open(taskwarrior_file,"r")

    for line in f:lines() do
        local t = taskwarrior_line2table(line)
        if (t["status"]=="pending") then
            table.insert(ret,t)
        end
    end
    f:close()

    return ret
end

