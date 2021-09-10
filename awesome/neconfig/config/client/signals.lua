-- Load libraries
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')


-- Load titlebars TODO MODIFY THIS LATER
require('modules.deco.titlebar')


-- Signal function to execute when a new client appears.
client.connect_signal(
    'manage',
    function (c)
        -- Set the windows at the slave (put it at the end of others instead of setting it master)
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position
        then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end

        -- Let the theme manage client if needed
        if beautiful.client_setup ~= nil
        then
            beautiful.client_setup(c)
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
if (user_vars_conf.binds.interactions.enable_sloppy_focus)
then
    client.connect_signal(
        'mouse::enter',
        function(c)
            c:emit_signal(
                'request::activate',
                'mouse_enter',
                {raise = false}
            )
        end
    )
end

-- Change border color on focus
client.connect_signal(
    'focus',
    function(c)
        c.border_color = beautiful.border_focus
    end
)
-- Change border color on lost focus
client.connect_signal(
    'unfocus',
    function(c)
        c.border_color = beautiful.border_normal
    end
)
