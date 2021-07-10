-- Standard Awesome libraries
local awful = require("awful")
local iconlist = require("modules.deco.iconlist")

-- Init layouts
local ls = awful.layout.suit

local tags = {}
local tagtext = { iconlist["home"], iconlist["terminal"], iconlist["code"], "4", "5", "6", "7", "8", "9" }
local taglayouts = ls.floating

-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(tagtext, s, taglayouts)

        -- for i in pairs(tagnames) do
        --     awful.tag.add(tagnames[i], {
        --         -- icon = "/path/to/icon.png",
        --         -- icon = "/home/nenikitov/Downloads/test-icon.png",
        --         screen = s,
        --         layout = taglayouts[i],
        --         gap_single_client = true,
        --         selected = (i == 1)
        --     })
        -- end

        -------

        -- awful.tag(tagnames, s, taglayouts)
    end
)

return tags
