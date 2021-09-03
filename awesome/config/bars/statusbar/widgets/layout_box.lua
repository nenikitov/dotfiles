-- Load libraries
local awful = require('awful')
local gears = require('gears')


function get_layout_box(screen)
    local layout_box = awful.widget.layoutbox(screen)
    local layoutbox_buttons = gears.table.join(
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
    )

    layout_box:buttons(layoutbox_buttons)

    return layout_box
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_layout_box(...) end }
)
