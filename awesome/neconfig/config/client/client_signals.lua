-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local menubar_utils = require('menubar.utils')
-- Load custom modules
local binds_user_conf = require('neconfig.config.user.binds_user_conf')
local user_vars_theme = beautiful.user_vars_theme
local widget_utils = require('neconfig.config.utils.widget_utils')
require('neconfig.config.bars.titlebar.titlebar')


-- Signal function to execute when a new client appears.
client.connect_signal(
    'manage',
    function (c)
        -- Set the windows at the slave (put it at the end of others instead of setting it master)
        if (awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position)
        then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end

        -- Force set GTK icon
        if (user_vars_theme.client.try_to_force_icon_theme)
        then
            local icon = menubar_utils.lookup_icon(c.instance)
            if (icon ~= nil)
            then
                c.icon = gears.surface(icon)._native
            end
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
if (binds_user_conf.interactions.enable_sloppy_focus)
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

client.connect_signal(
    'property::geometry',
    function (c)
        if c.maximized or c.fullscreen then
            c.shape = gears.shape.rectangle
        else
            c.shape = widget_utils.r_rect(10)
        end
    end
)
