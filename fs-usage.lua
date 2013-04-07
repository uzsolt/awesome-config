function get_fs_usage()
    local f = io.popen("LC_ALL=C /bin/df -m")
    -- skip the first line
    f:read("*line")
    local ret = {}

    s = f:read("*line")
    while s do
        local _,_,mp = string.find(s,".*%%%s*(.+)")
        ret[mp] = {}
        _,_, ret[mp].dev,
            ret[mp].size,
            ret[mp].used,
            ret[mp].avail,
            ret[mp].perc = string.find(s,"(%S+)%D*(%d+)%D*(%d+)%D*(%d+)%D*(%d+)%%")
        s = f:read("*line")
    end

    f:close()
    return ret
end

