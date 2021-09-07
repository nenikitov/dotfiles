-- Standard Awesome libraries
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local user_vars = require('neconfig.config.user.user_vars')


-- Get variables
local super_key = user_vars.binds.keys.super_key


-- Create the button binds for tag list
function get_taglist_buttons()
    local taglist_buttons = gears.table.join(
        -- View only the current tag on LMB
        awful.button(
            { }, 1,
            function(t)
                t:view_only()
            end
        ),
        -- Move to tag on SUPER + LMB
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
        -- Toggle tag on SUPER + RMB
        awful.button(
            { super_key }, 3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        -- Go to next tag on FTMB
        awful.button(
            { }, 4,
            function(t)
                awful.tag.viewnext(t.screen)
            end
        ),
        -- Go to previous tag on BTMB
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
    {  __call = function(_, ...) return get_taglist_buttons(...) end }
)