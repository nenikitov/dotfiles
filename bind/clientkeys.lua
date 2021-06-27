local gears = require("gears")
local awful = require("awful")

local modkey = rc.uservars.modkey

function getclientkeys()
    -- Bind keyboard keys to interact with clients
    local clientkeys = gears.table.join(
        -- Toggle fullscreen on MODKEY + F
        awful.key({ modkey }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }
        ),
        -- Close client on MODKEY + SHIFT + C
        awful.key(
            { modkey, "Shift" }, "c",
            function (c)
                c:kill()
            end,
            { description = "close", group = "client" }
        ),
        -- Toggle floating client on MODKEY + CTRL + SPACE
        awful.key(
            { modkey, "Control" }, "space",
            awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }
        ),
        -- Move client to master on MODKEY + CTRL + ENTER
        awful.key(
            { modkey, "Control" }, "Return",
            function (c)
                c:swap(awful.client.getmaster())
            end,
            { description = "move to master", group = "client" }
        ),
        -- Move client to another screen on MODKEY + O
        awful.key(
            { modkey }, "o",
            function (c)
                c:move_to_screen()
            end,
            { description = "move to screen", group = "client" }
        ),
        -- Pin client to top on MODKEY + T
        awful.key(
            { modkey }, "t",
            function (c)
                c.ontop = not c.ontop
            end,
            { description = "toggle keep on top", group = "client" }
        ),
        -- Minimize client on MODKEY + N
        awful.key(
            { modkey }, "n",
            function (c)
                c.minimized = true
            end,
            { description = "minimize", group = "client" }
        ),
        -- Maximize client on MODKEY + M
        awful.key(
            { modkey }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }
        ),
        -- Maximize client verically on MODKEY + CTRL + M
        awful.key(
            { modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }
        ),
        -- Maximize client horizontally on MODKEY + CTRL + M
        awful.key({ modkey, "Shift" }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            { description = "(un)maximize horizontally", group = "client" }
        )
    )

    return clientkeys
end

return setmetatable(
    {},
    {  __call = function(_, ...) return getclientkeys(...) end }
)

