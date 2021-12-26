-- Load libraries
local awful = require('awful')
-- Load custom modules
local binds_user_conf = require('neconfig.config.user.binds_user_conf')

-- Get variables
local super_key = binds_user_conf.keys.super_key


-- Create the mouse button binds for tag list
local taglist_buttons = {
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
}

return taglist_buttons
