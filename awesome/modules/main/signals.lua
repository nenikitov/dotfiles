-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Load titlebars
require("modules.deco.titlebar")

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function (c)
        -- Set the shape to be rounded rectangle
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end

        -- Set the windows at the slave (put it at the end of others instead of setting it master)
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal(
            "request::activate",
            "mouse_enter",
            {raise = false}
        )
    end
)

-- Change border color on focus
client.connect_signal(
    "focus",
    function(c)
        -- c.border_color = beautiful.border_focus
    end
)
-- Change border color on lost focus
client.connect_signal(
    "unfocus",
    function(c)
        -- c.border_color = beautiful.border_normal
    end
)
