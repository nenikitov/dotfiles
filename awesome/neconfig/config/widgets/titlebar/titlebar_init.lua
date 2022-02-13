-- Load libraries
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
-- Load custom modules
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local utils_colors = require('neconfig.config.utils.utils_colors')
local titlebar_widget_template = require('neconfig.config.widgets.titlebar.titlebar_widget_template')


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    'request::titlebars',
    function(c)
        gears.timer.weak_start_new(
            0.5,
            function()
                local titlebar_color = utils_colors.get_client_side_color(c, 'top')

                naughty.notify {
                    text = 'updated ' .. c.name .. ' to ' .. titlebar_color
                }
                local widget_template = titlebar_widget_template(c, titlebar_color)

                local client_titlebar = awful.titlebar(
                    c,
                    {
                        position = user_titlebar.position,
                        bg = titlebar_color
                    }
                )
                client_titlebar:setup(widget_template)
            end
        )
    end
)
