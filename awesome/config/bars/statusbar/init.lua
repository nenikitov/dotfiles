-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local user_vars = require('config.user.user_vars')


-- Get variables
local parameters = user_vars.statusbar


-- Create widgets that are the same for all screens
local widget_keyboard_layout = require('config.bars.statusbar.widgets.keyboard_layout')
local widget_systray = require('config.bars.statusbar.widgets.systray')
local widget_clock = require('config.bars.statusbar.widgets.clock')


-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        -- Create widgets that are the same for all screens
        local widget_layout_box = require('config.bars.statusbar.widgets.layout_box')(s)


        -- Strore widgets for screen
        s.statusbar_widgets = {
            keyboard_layout = widget_keyboard_layout,
            systray = widget_systray,
            clock = widget_clock,
            layout_box = widget_layout_box
        }


        -- Generate the container
        s.statusbar = awful.wibar {
            position = 'bottom',
            screen = s,
            height = parameters.height,
        }


        -- Popilate it
        s.statusbar:setup {
            -- Left widgets
            {
                s.statusbar_widgets.layout_box,

                layout = wibox.layout.fixed.horizontal,
            },
            -- Middle widget
            {
                layout = wibox.layout.fixed.horizontal,
            }, 
            -- Right widgets
            {
                s.statusbar_widgets.systray,
                s.statusbar_widgets.keyboard_layout,
                s.statusbar_widgets.clock,

                layout = wibox.layout.fixed.horizontal,
            },

            layout = wibox.layout.align.horizontal,
        }
    end
)
