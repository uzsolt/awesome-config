val = nil
keybinding({ modkey}, "c", function ()
    awful.prompt.run({  text = val and tostring(val),
            selectall = true,
            fg_cursor = "black",bg_cursor="orange",
            prompt = "<span color='#00A5AB'>Calc:</span> " }, mypromptbox,
            function(expr)
              val = awful.util.eval(expr)
              naughty.notify({ text = expr .. ' = <span color="white">' .. val .. "</span>",
                               timeout = 0,
                               run = function() io.popen("echo '".. val .. "' | xsel -i"):close() end, })
            end,
            nil, awful.util.getdir("cache") .. "/calc")
end):add()

