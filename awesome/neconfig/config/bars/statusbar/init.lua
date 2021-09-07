-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_menu = require('neconfig.config.user.user_menu')
local user_vars = require('neconfig.config.user.user_vars')
require('neconfig.config.utils.widget_utils')


-- Get info about complex widgets
local layoutbox_buttons = require('neconfig.config.bars.statusbar.widgets.layoutbox_buttons')()
local widget_gap = beautiful.useless_gap * 2
local real_widget_height = user_vars.statusbar.height - widget_gap * 2

-- Widgets that are the same on all screen
local menu = require('neconfig.config.bars.statusbar.widgets.menu.menu_init')
local keyboardlayout = require('neconfig.config.bars.statusbar.widgets.keyboard.keyboard_init')
local textclock = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_init')
local systray = wibox.widget.systray()
systray:set_base_size(20)


-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        s.statusbar = {}
        s.statusbar.widgets = {}


        -- Generate and initialize all widgets
        -- Left
        s.statusbar.widgets.menu = menu
        s.statusbar.widgets.taglist = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_init')(s)
        s.statusbar.widgets.promptbox = awful.widget.prompt()
        -- Center
        s.statusbar.widgets.tasklist = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_init')(s)
        -- Right
        s.statusbar.widgets.systray = systray
        s.statusbar.widgets.keyboardlayout = keyboardlayout
        s.statusbar.widgets.textclock = textclock
        s.statusbar.widgets.layoutbox = awful.widget.layoutbox(s)
        s.statusbar.widgets.layoutbox:buttons(layoutbox_buttons)

        -- Generate empty background wibar
        s.statusbar.wibar = awful.wibar {
            position = user_vars.statusbar.position,
            screen = s,
            height = user_vars.statusbar.height,
        }
        s.statusbar.wibar:setup {
            layout = wibox.layout.flex.horizontal
        }


        -- Generate 3 main containers where all the widgets will be placed
        -- Left container with launcher and tag list
        s.statusbar.left_container = awful.popup {
            screen = s,
            placement = function(wi)
                return awful.placement.top_left(wi, { margins = widget_gap })
            end,
            widget = {},
        }
        s.statusbar.left_container:setup {
            {
                {
                    -- TODO make this more readable
                    {
                        s.statusbar.widgets.menu,
                        widget = wibox.container.background,
                        forced_height = real_widget_height
                    },
                    s.statusbar.widgets.taglist,
                    s.statusbar.widgets.promptbox,

                    layout = wibox.layout.fixed.horizontal
                },

                widget = wibox.container.background,
                forced_height = real_widget_height
            },
            layout = wibox.layout.fixed.horizontal
        }

        -- Middle container with tasklist
        s.statusbar.middle_container = awful.popup {
            screen = s,
            placement = function(wi)
                return awful.placement.top(wi, { margins = widget_gap })
            end,
            widget = {}
        }
        --awful.placement.top(s.statusbar.middle_container, { margins = widget_gap })
        s.statusbar.middle_container:setup {
            {
                s.statusbar.widgets.tasklist,

                widget = wibox.container.background,
                forced_height = real_widget_height,
                -- TODO improve tasklist widget template to have fixed size so there is no forced_width here
                forced_width = 800
            },
            layout = wibox.layout.fixed.horizontal
        }
        awful.placement.top(s.statusbar.middle_container, { margins = widget_gap })

        -- Right container
        s.statusbar.right_container = awful.popup {
            screen = s,
            placement = function(wi)
                return awful.placement.top_right(wi, { margins = widget_gap })
            end,
            widget = {}
        }
        awful.placement.top_right(s.statusbar.right_container, { margins = widget_gap })
        s.statusbar.right_container:setup {
            {
                {
                    {
                        s.statusbar.widgets.systray,
                        widget = wibox.container.background,
                        forced_height = real_widget_height
                    },
                    s.statusbar.widgets.keyboardlayout,
                    s.statusbar.widgets.textclock,
                    -- TODO make this more readable
                    {
                        s.statusbar.widgets.layoutbox,
                        widget = wibox.container.background,
                        forced_width = real_widget_height
                    },

                    layout = wibox.layout.fixed.horizontal
                },

                widget = wibox.container.background,
                forced_height = real_widget_height
            },
            layout = wibox.layout.fixed.horizontal
        }

    end
)
