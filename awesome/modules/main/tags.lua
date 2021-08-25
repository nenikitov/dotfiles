-- Standard Awesome libraries
local awful = require("awful")
local iconlist = require("modules.deco.iconlist")

-- Init layouts
local tagtext = {
    iconlist["home"],
    iconlist["terminal"],
    iconlist["code"],
    iconlist["study"],
    iconlist["media"]
}
rc.tagnum = #(tagtext)

local tags = {}
local taglayouts = awful.layout.suit.floating

-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(tagtext, s, taglayouts)
    end
)

return tags
