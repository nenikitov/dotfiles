-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_desktop = require('neconfig.user.config.user_desktop')

-- Get variables
local tag_names = user_desktop.tag_names
local tag_layout = user_desktop.layouts[1]


-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(tag_names, s, tag_layout)
    end
)
