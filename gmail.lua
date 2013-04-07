require("etree")

function hook_gmail()
    local xfile = io.open("/home/users/zsolt/gmail-unread")
    local str = xfile:read("*all")
    xfile:close()
    emails = {}

    xmlt = etree.fromstring(str)

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
end
