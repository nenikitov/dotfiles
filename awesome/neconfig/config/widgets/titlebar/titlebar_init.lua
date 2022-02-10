-- Load libraries
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local titlebar_buttons = require('neconfig.config.widgets.titlebar.tilebar_buttons')

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    'request::titlebars',
    function(c)
        -- Buttons for the titlebar
        local buttons = titlebar_buttons(c)

        local client_titlebar = awful.titlebar(
            c,
            {
                position = user_titlebar.position
            }
        )
        client_titlebar:setup {
            -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            -- Middle
            {
                -- Title
                {
                    align = 'center',
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            -- Right
            {
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),

                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton(c),

                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)
