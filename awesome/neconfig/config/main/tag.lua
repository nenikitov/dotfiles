-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Get variables
local tag_names = user_vars_conf.desktop.tag_names
local tag_layout = user_vars_conf.desktop.layouts[1]


-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(tag_names, s, tag_layout)
    end
)