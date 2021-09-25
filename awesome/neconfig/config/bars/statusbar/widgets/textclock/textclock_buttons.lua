-- Load libraries
local gears = require('gears')
local awful = require('awful')


-- Create the button binds for textclock
local function get_textclock_buttons(calendar)
    local layoutbox_buttons = gears.table.join(
        awful.button(
            { }, 1,
            function()

            end
        )
    )

    return layoutbox_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_textclock_buttons(...) end }
)
