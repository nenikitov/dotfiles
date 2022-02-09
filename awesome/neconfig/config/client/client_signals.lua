-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local menubar_utils = require('menubar.utils')
local gears = require('gears')
-- Load custom modules
local user_interactions = require('neconfig.user.config.binds.user_interactions')
local user_apps_appearance = require('neconfig.user.appearance.user_apps_appearance')
local user_desktop_appearance = require('neconfig.user.appearance.user_desktop_appearance')
local utils_shapes = require('neconfig.config.utils.utils_shapes')
require('neconfig.config.widgets.titlebar.titlebar_init')



local function update_client_shape(c)
    if not (c.maximized or c.fullscreen) then
        c.shape = c.custom_shape
    else
        c.shape = nil
    end
end
local function construct_custom_shape()
    local u_round = user_apps_appearance.shape.round
    local u_radius = user_apps_appearance.shape.radius

    local titlebar_side = 'top'
    local titlebar_opp_side = utils_shapes.opposite_side(titlebar_side)

    local round = u_round
    if type(u_round) == 'table' then
        round[titlebar_side] = round['titlebar'] or round[titlebar_side]
        round[titlebar_opp_side] = round['other'] or round[titlebar_opp_side]

        round = {
            tr = round.tr or round.top or round.right,
            tl = round.tl or round.top or round.left,
            br = round.br or round.bottom or round.right,
            bl = round.bl or round.bottom or round.left,
        }
    end

    local radius = u_radius
    if type(u_radius) == 'table' then
        radius[titlebar_side] = radius['titlebar'] or radius[titlebar_side]
        radius[titlebar_opp_side] = radius['other'] or radius[titlebar_opp_side]

        radius = {
            tr = radius.tr or radius.top or radius.right,
            tl = radius.tl or radius.top or radius.left,
            br = radius.br or radius.bottom or radius.right,
            bl = radius.bl or radius.bottom or radius.left,
        }
    end

    return utils_shapes.better_rect {
        round = round,
        radius = radius
    }
end


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
        if user_desktop_appearance.try_to_force_gtk_icon_theme then
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


        -- Generate rounded shape to switch to it when client is not maximized and update the shape
        c.custom_shape = construct_custom_shape()
        update_client_shape(c)
    end
)

-- Update client shape when it is resized to be maximized
client.connect_signal(
    'property::maximized',
    function(c)
        update_client_shape(c)
    end
)
client.connect_signal(
    'property::fullscreen',
    function(c)
        update_client_shape(c)
    end
)

-- Enable sloppy focus, so that focus follows mouse.
if (user_interactions.focus.sloppy_focus) then
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
