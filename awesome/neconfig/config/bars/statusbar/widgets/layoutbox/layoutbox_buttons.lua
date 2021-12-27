-- Load libraries
local gears = require('gears')
local awful = require('awful')


-- Create the mouse button binds for layoutbox
local layoutbox_buttons = {
    -- Go to next layout on LMB
    awful.button(
        { }, 1,
        function()
            awful.layout.inc(1)
        end
    ),
    -- Go to previous layout on RMB
    awful.button(
        { }, 3,
        function()
            awful.layout.inc(-1)
        end
    )
}

return layoutbox_buttons
