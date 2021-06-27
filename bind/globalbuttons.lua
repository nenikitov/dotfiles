-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")

function getglobalbuttons()
    -- Bind mouse buttons to interact with Awesome WM itself
    local globalbuttons = gears.table.join(
        -- Toggle menu on RMB
        awful.button(
            { }, 3,
            function()
                rc.menu:toggle()
            end
        ),
        -- Go to next tag on FTMB
        awful.button(
            { }, 4,
            awful.tag.viewnext
        ),
        -- Go to previous tag on BTMB
        awful.button(
            { }, 5,
            awful.tag.viewprev
        )
    )

    return globalbuttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return getglobalbuttons(...) end }
)
