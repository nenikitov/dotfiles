-- Load libraries
local gears = require('gears')
local awful = require('awful')
-- Load custom modules
local user_conf_binds = require('neconfig.config.user.user_conf_binds')

-- Get variables
local super_key = user_conf_binds.keys.super_key


-- Create the mouse button binds for tag list
local function get_taglist_buttons()
    local taglist_buttons = gears.table.join(
        -- View only the current tag on LMB
        awful.button(
            { }, 1,
            function(t)
                t:view_only()
            end
        ),
        -- Move current client to tag on SUPER + LMB
        awful.button(
            { super_key }, 1,
            function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end
        ),
        -- Toggle visibility on RMB
        awful.button(
            { }, 3,
            awful.tag.viewtoggle
        ),
        -- Toggle tag for the current client on SUPER + RMB
        awful.button(
            { super_key }, 3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        -- Go to next tag on SCROLL UP
        awful.button(
            { }, 4,
            function(t)
                awful.tag.viewnext(t.screen)
            end
        ),
        -- Go to previous tag on SCROLL DOWN
        awful.button(
            { }, 5,
            function(t)
                awful.tag.viewprev(t.screen)
            end
        )
    )

    return taglist_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_taglist_buttons() end }
)
