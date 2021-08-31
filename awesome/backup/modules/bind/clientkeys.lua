-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
-- Global variables
local modkey = rc.uservars.modkey

function getclientkeys()
    -- Bind keyboard keys to interact with clients
    local clientkeys = gears.table.join(
        -- Toggle fullscreen on MOD + F
        awful.key(
            { modkey }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }
        ),
        -- Close client on MOD + SHIFT + C
        awful.key(
            { modkey, "Shift" }, "c",
            function (c)
                c:kill()
            end,
            { description = "close", group = "client" }
        ),
        -- Toggle floating client on MOD + CTRL + SPACE
        awful.key(
            { modkey, "Control" }, "space",
            awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }
        ),
        -- Move client to master on MOD + CTRL + ENTER
        awful.key(
            { modkey, "Control" }, "Return",
            function (c)
                c:swap(awful.client.getmaster())
            end,
            { description = "move to master", group = "client" }
        ),
        -- Move client to another screen on MOD + O
        awful.key(
            { modkey }, "o",
            function (c)
                c:move_to_screen()
            end,
            { description = "move to screen", group = "client" }
        ),
        -- Pin client to top on MOD + T
        awful.key(
            { modkey }, "t",
            function (c)
                c.ontop = not c.ontop
            end,
            { description = "toggle keep on top", group = "client" }
        ),
        -- Minimize client on MOD + N
        awful.key(
            { modkey }, "n",
            function (c)
                c.minimized = true
            end,
            { description = "minimize", group = "client" }
        ),
        -- Maximize client on MOD + M
        awful.key(
            { modkey }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }
        ),
        -- Maximize client verically on MOD + CTRL + M
        awful.key(
            { modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }
        ),
        -- Maximize client horizontally on MOD + CTRL + M
        awful.key(
            { modkey, "Shift" }, "m",
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

