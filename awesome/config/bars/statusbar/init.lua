-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_menu = require('config.user.user_menu')
local user_vars = require('config.user.user_vars')


-- Get info about complex widgets
local layoutbox_buttons = require('config.bars.statusbar.widgets.layoutbox_buttons')()


-- Widgets that are the same on all screen
local launcher = require('config.bars.statusbar.widgets.menu.menu_init')
local keyboardlayout = require('config.bars.statusbar.widgets.keyboard.keyboard_init')
local textclock = require('config.bars.statusbar.widgets.textclock.textclock_init')
local systray = wibox.widget.systray()


-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        -- Generate widgets that are unique for each screen
        s.promptbox = awful.widget.prompt()
        s.taglist = require('config.bars.statusbar.widgets.taglist.taglist_init')(s)
        s.tasklist = require('config.bars.statusbar.widgets.tasklist.tasklist_init')(s)
        s.layoutbox = awful.widget.layoutbox(s)
        s.layoutbox:buttons(layoutbox_buttons)
        
        -- Generate the container
        s.wibox = awful.wibar {
            position = 'top',
            screen = s,
        }


        -- Add widgets to the wibar
        s.wibox:setup {
            -- Left widgets
            {
                launcher,
                s.taglist,
                s.promptbox,

                layout = wibox.layout.fixed.horizontal,
            },
            -- Middle widget
            s.tasklist, 
            -- Right widgets
            {
                keyboardlayout,
                systray,
                textclock,
                s.layoutbox,

                layout = wibox.layout.fixed.horizontal,
            },

            layout = wibox.layout.align.horizontal,
        }
    end
)
