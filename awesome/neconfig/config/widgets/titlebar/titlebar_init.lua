-- Load libraries
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local titlebar_widget_template = require('neconfig.config.widgets.titlebar.titlebar_widget_template')


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    'request::titlebars',
    function(c)
        local widget_template = titlebar_widget_template(c)

        local client_titlebar = awful.titlebar(
            c,
            {
                position = user_titlebar.position
            }
        )
        client_titlebar:setup(widget_template)
    end
)
