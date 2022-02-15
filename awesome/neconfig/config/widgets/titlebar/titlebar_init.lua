-- Load libraries
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
-- Load custom modules
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local user_look_titlebar = require('neconfig.user.look.widgets.user_look_titlebar')
local utils_colors = require('neconfig.config.utils.utils_colors')
local titlebar_widget_template = require('neconfig.config.widgets.titlebar.titlebar_widget_template')

-- Update all titlebar colors now
client.connect_signal(
    'titlebar::update_now',
    function(c)
        -- Get color from user colors
        local all_colors = {
            normal = user_look_titlebar.bar.colors.normal,
            focus  = user_look_titlebar.bar.colors.focus or user_look_titlebar.bar.colors.normal,
            urgent = user_look_titlebar.bar.colors.urgent or user_look_titlebar.bar.colors.normal
        }
        local client_state = (client.focus == c) and 'focus' or 'normal'
        client_state = c.urgent and 'urgent' or client_state
        local current_color = all_colors[client_state]

        -- Update client color
        local client_color = utils_colors.get_client_side_color(c, user_titlebar.position)
        if client_color == '#000000' or client_color == '#00000000' then
            if c.previous_client_color then
                client_color = c.previous_client_color
            end
        end
        c.previous_client_color = client_color

        -- Replace 'border' or 'client' colors by their values
        local col_bg = current_color.bg
        if current_color.bg == 'client' then
            col_bg = client_color
        elseif current_color.bg == 'border' then
            col_bg = c.border_color
        end

        awful.titlebar(
            c,
            {
                position = user_titlebar.position,
                bg = col_bg
            }
        )
    end
)
-- Update all titlebar colors with a slight delay
client.connect_signal(
    'titlebar::update_soon',
    function(c)
        gears.timer.weak_start_new(
            0.15,
            function()
                c:emit_signal('titlebar::update_now')
            end
        )
    end
)


-- Add a titlebar if titlebars_enabled is set to true in the rules
client.connect_signal(
    'request::titlebars',
    function(c)
        local client_titlebar = awful.titlebar(
            c,
            {
                position = user_titlebar.position,
            }
        )

        client_titlebar:setup(titlebar_widget_template(c))

        c:emit_signal('titlebar::update_soon')
    end
)

-- Force update titlebar colors when borders change
client.connect_signal(
    'request::border',
    function(c)
        c:emit_signal('titlebar::update_now')
        c:emit_signal('titlebar::update_soon')
    end
)
