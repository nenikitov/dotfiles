-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Get variables
local should_number = user_vars_conf.statusbar.widgets.taglist.number
local tag_names = user_vars_conf.desktop.tag_names
local tag_layout = user_vars_conf.desktop.layouts[1]


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
