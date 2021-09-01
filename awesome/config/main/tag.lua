-- Load libraries
local awful = require('awful')
local user_vars = require('config.user.user_vars')


-- Get variables
local tag_names = user_vars.desktop.tag_names
local tag_layout = user_vars.desktop.layouts[1]


-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(tag_names, s, tag_layout)
    end
)