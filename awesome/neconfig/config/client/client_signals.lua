-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local menubar_utils = require('menubar.utils')
-- Load custom modules
local user_interactions = require('neconfig.user.config.binds.user_interactions')
require('neconfig.config.widgets.titlebar.titlebar_init')


-- Signal function to execute when a new client appears.
client.connect_signal(
    'manage',
    function(c)
        -- Set the windows at the slave (put it at the end of others instead of setting it master)
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end

        -- Force set GTK icon
        if false then
            if c.instance ~= nil then
                local icon = menubar_utils.lookup_icon(c.instance)
                local lower_icon = menubar_utils.lookup_icon(c.instance:lower())

                if icon ~= nil then
                    c.icon = gears.surface(icon)._native
                elseif lower_icon ~= nil then
                    c.icon = gears.surface(lower_icon)._native
                end
            elseif c.icon == nil then
                c.icon = gears.surface(menubar_utils.lookup_icon('application-default-icon'))._native
            end
        end

        -- Set client shape
        if not (c.maximized or c.fullscreen) then
            c.shape = function(cr, w, h)
                return gears.shape.rounded_rect(cr, w, h, 10)
            end
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
if (user_interactions.enable_sloppy_focus) then
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

-- ! This slows down the window manager
-- TODO find a better way of changing window shape
-- client.connect_signal(
--     'property::geometry',
--     function (c)
--         if c.maximized or c.fullscreen then
--             c.shape = gears.shape.rectangle
--         else
--             c.shape = widget_utils.r_rect(10)
--         end
--     end
-- )
