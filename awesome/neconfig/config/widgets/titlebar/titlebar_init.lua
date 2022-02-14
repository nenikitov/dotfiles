-- Load libraries
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
-- Load custom modules
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local utils_colors = require('neconfig.config.utils.utils_colors')
local titlebar_widget_template = require('neconfig.config.widgets.titlebar.titlebar_widget_template')


-- Add a titlebar if titlebars_enabled is set to true in the rules
client.connect_signal(
    'titlebar::update_now',
    function(c)
        local titlebar_color = utils_colors.get_client_side_color(c, user_titlebar.position)

        if titlebar_color == '#000000' or titlebar_color == '#00000000' then
            titlebar_color = c.previous_titlebar_color
        end

        awful.titlebar(
            c,
            {
                position = user_titlebar.position,
                bg = titlebar_color
            }
        )

        c.previous_titlebar_color = titlebar_color
    end
)

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

client.connect_signal(
    'request::border',
    function(c)
        c:emit_signal('titlebar::update_soon')
    end
)

client.connect_signal(
    'request::manage',
    function(c)
        c:emit_signal('titlebar::update_soon')
    end
)
