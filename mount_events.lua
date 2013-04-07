mount_dev = { "mount1", "mount2", "mount3" }
mounts = {}
dev_notify = {}

for _,j in pairs(mount_dev) do
    mounts[j] = {}
    mounts[j].mounted = false
    dev_notify[j] = nil
    iconboxes[j]:add_signal("mouse::enter", function ()
        if mounts[j].mounted then
            local df = io.popen("df -h " .. mounts[j].dev .. " | awk {'if (NR==2) {print $3 \"/\" $2}'}")
            local df = df:read("*line")
            dev_notify[j] = naughty.notify({
                title = "Információ",
                text = coloring("Eszköz: ","lightblue") .. 
                    coloring(mounts[j].dev,"yellow") .. "\n" ..
                    coloring("Útvonal: ","lightblue") ..
                    coloring(mounts[j].path,"yellow") .. "\n" .. 
                    coloring("Foglalt: ","lightblue") .. df
            })
        else
            dev_notify[j] = naughty.notify({
                title="Információ",
                text="nincs csatolva"
            })
        end
    end)
    iconboxes[j]:add_signal("mouse::leave", function ()
        if dev_notify[j] then
            naughty.destroy(dev_notify[j])
            dev_notify[j] = nil
        end
    end)
end

function count_mounted_devices()
    local ret = 1
    for key,val in pairs(mounts) do
        ret = ret + ( (val.mounted) and 1 or 0 )
    end
    return ret
end

function mount_events(mount,mountpath,dev)
    local naughty_color = "#444444"
    if (mount=="mount") then
        local nr_md = count_mounted_devices()
        naughty.notify({
            icon = "/home/users/zsolt/awesome-resources/icons/mount-kicsi.png",
            text = dev .. " => \n\t" .. mountpath,
            bg = naughty_color
        })
        str_nrmd = "mount" .. nr_md
        mounts[str_nrmd] = mounts[str_nrmd] or {}
        mounts[str_nrmd] = {
            mounted = true,
            count = nr_md,
            dev = dev,
            path = mountpath
        }
        iconboxes["mount"..nr_md].image=ib_Image("pendrive.png")
    else -- umount
        naughty.notify({
            icon = "/home/users/zsolt/awesome-resources/icons/umount-kicsi.png",
            text = dev .. " => \n\t" .. mountpath,
            bg = naughty_color
        })
        for key,val in pairs(mounts) do
            if val.dev == dev then
                mounts[key].mounted = false
                iconboxes["mount"..mounts[key].count].image = ib_Image(image_not_mounted)
                break
            end
        end
    end
end

