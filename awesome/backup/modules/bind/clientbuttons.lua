-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")

function getclientbuttons()
    -- Bind mouse buttons to interact with clients
    local clientbuttons = gears.table.join(
        -- Activate client on LMB
        awful.button(
            { }, 1,
            function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
            end
        ),
        -- Move client on MOD + LMB
        awful.button(
            { modkey }, 1,
            function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.move(c)
            end
        ),
        -- Resize client on MOD + RMB
        awful.button(
            { modkey }, 3,
            function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.resize(c)
            end
        )
    )

    return clientbuttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return getclientbuttons(...) end }
)
