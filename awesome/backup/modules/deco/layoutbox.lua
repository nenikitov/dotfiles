-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")

function getlayoutbox()
    -- Create the buttons for layoutbox
    local layoutbox_buttons = gears.table.join(
        -- Go to next layout on LMB
        awful.button(
            { },
            1,
            function()
                awful.layout.inc(1)
            end
        ),
        -- Go to previous layout on RMB
        awful.button(
            { },
            3,
            function()
                awful.layout.inc(-1)
            end
        )
    )

    return layoutbox_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return getlayoutbox(...) end }
)
