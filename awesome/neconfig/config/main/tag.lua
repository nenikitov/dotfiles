-- Load libraries
local awful = require('awful')
-- Load custom modules
local desktop_user_conf = require('neconfig.config.user.desktop_user_conf')
local statusbar_user_conf = require('neconfig.config.user.statusbar_user_conf')

-- Get variables
-- TODO move to taglist widget itself
local should_number = false
local tag_names = desktop_user_conf.tag_names
local tag_layout = desktop_user_conf.layouts[1]


-- Add layouts to each screen
awful.screen.connect_for_each_screen(
    function(s)
        for i, tag in pairs(tag_names)
        do
            -- Append numbers before tag name
            local tag_name = tag
            if (should_number)
            then
                tag_name = i .. ' ' .. tag_name
            end
            -- Add a tag
            awful.tag.add(
                tag_name,
                {
                    layout = tag_layout,
                    screen = s,
                    selected = (i == 1)
                }
            )
        end
    end
)
