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
    'titlebar::update_color',
    function(c)
        gears.timer.weak_start_new(
            0.15,
            function()
                local titlebar_color = utils_colors.get_client_side_color(c, user_titlebar.position)
                awful.titlebar(
                    c,
                    {
                        position = user_titlebar.position,
                        bg = titlebar_color
                    }
                )
            end
        )
    end
)


client.connect_signal(
    'request::titlebars',
    function(c)
        local widget_template = titlebar_widget_template(c)

        local client_titlebar = awful.titlebar(
            c,
            {
                position = user_titlebar.position,
            }
        )

        client_titlebar:setup(widget_template)

        c:emit_signal('titlebar::update_color')
    end
)

client.connect_signal(
    'request::border',
    function(c)
        c:emit_signal('titlebar::update_color')
    end
)
