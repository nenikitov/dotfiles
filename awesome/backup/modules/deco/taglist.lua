-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

function gettaglist()
    -- Create the buttons for tag list
    local buttons = gears.table.join(
        -- View only the current tag on LMB
        awful.button(
            { },
            1,
            function(t)
                t:view_only()
            end
        ),
        -- Move to tag on MOD + LMB
        awful.button(
            { modkey },
            1,
            function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end
        ),
        -- Toggle visibility on RMB
        awful.button(
            { },
            3,
            awful.tag.viewtoggle
        ),
        -- Toggle tag on MOD + RMB
        awful.button(
            { modkey },
            3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        -- Go to next tag on FTMB
        awful.button(
            { },
            4,
            function(t)
                awful.tag.viewnext(t.screen)
            end
        ),
        -- Go to previous tag on BTMB
        awful.button(
            { },
            5,
            function(t)
                awful.tag.viewprev(t.screen)
            end
        )
    )

    return buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return gettaglist(...) end }
)
