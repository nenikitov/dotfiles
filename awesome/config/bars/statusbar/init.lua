-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_menu = require('config.user.user_menu')
local user_vars = require('config.user.user_vars')
require('config.utils.widget_utils')


-- Get info about complex widgets
local layoutbox_buttons = require('config.bars.statusbar.widgets.layoutbox_buttons')()


-- Widgets that are the same on all screen
local menu = require('config.bars.statusbar.widgets.menu.menu_init')
local keyboardlayout = require('config.bars.statusbar.widgets.keyboard.keyboard_init')
local textclock = require('config.bars.statusbar.widgets.textclock.textclock_init')
local systray = wibox.widget.systray()


-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        s.statusbar = {}
        s.statusbar.widgets = {}
        -- Generate and initialize all widgets
        s.statusbar.widgets.menu = menu;

        -- Generate empty background wibar
        s.statusbar.wibar = awful.wibar {
            position = user_vars.statusbar.position,
            screen = s,
            height = user_vars.statusbar.height,
        }
        -- Initialize
        s.statusbar.wibar:setup {
            layout = wibox.layout.flex.horizontal
        }

        -- Generate 3 main containers where all the widgets will be placed
        -- Left container with launcher and tag list
        s.statusbar.left_container = awful.popup {
            screen = s,
            placement = awful.placement.top_left,
            widget = {},
        }
        -- Initialize
        s.statusbar.left_container:setup {
            {
                s.statusbar.widgets.menu,
                widget = wibox.container.background,
                forced_height = 30,
            },
            {
                s.taglist,
                widget = wibox.container.background,
                forced_width = 30,
                forced_height = 30,
            },
            layout = wibox.layout.fixed.horizontal
        }

        -- Generate widgets that are unique for each screen
        s.promptbox = awful.widget.prompt()
        s.taglist = require('config.bars.statusbar.widgets.taglist.taglist_init')(s)
        s.tasklist = require('config.bars.statusbar.widgets.tasklist.tasklist_init')(s)
        s.layoutbox = awful.widget.layoutbox(s)
        s.layoutbox:buttons(layoutbox_buttons)
        


        -- Use awful.popup for independent containers that can addapt to width of widgets
        

        -- TODO delete this later
        s.testbar = awful.wibar {
            position = user_vars.statusbar.position,
            screen = s,
            height = user_vars.statusbar.height,
        }
        local final_widget = {
            -- Left widgets
            {
                menu,
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
        s.testbar:setup {
            final_widget,

            layout = wibox.layout.flex.horizontal,
        }
    end
)
