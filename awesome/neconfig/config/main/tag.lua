-- Load libraries
local awful = require('awful')
-- Load custom modules
local desktop_user_conf = require('neconfig.config.user.desktop_user_conf')

-- Get variables
local tag_names = desktop_user_conf.tag_names
local tag_layout = desktop_user_conf.layouts[1]


-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(tag_names, s, tag_layout)
    end
)
