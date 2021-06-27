-- Standard Awesome libraries
local awful = require("awful")

-- Init layouts
local ls = awful.layout.suit

local tags = {}
local tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
local taglayouts = ls.floating

-- Add layouts to each screen
awful.screen.connect_for_each_screen(function(s)
    awful.tag(tagnames, s, taglayouts)
end)

return tags
