-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("modules.main.utils")

-- Load custom modules
wallpaper = require("modules.deco.wallpaper")
-- Get info about complex widgets
local taglist_info = require("modules.deco.taglist")()
local tasklist_info = require("modules.deco.tasklist")()
local layoutbox_buttons = require("modules.deco.layoutbox")()

-- {{{ Generate widgets that are the same on all the screens
-- Launcher menu
local launchermenu = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = rc.menu
})
-- Current keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
-- Clock
local textclock = wibox.widget.textclock()
-- Systray for background applications
local systray = wibox.widget.systray()
systray.base_size = 26
-- }}}


awful.screen.connect_for_each_screen(
    -- Set up the status bar (top bar) for each screen
    function(s)
        -- Set wallpaper for each screen
        set_wallpaper(s)

        -- {{{ Generate widgets that are unique for each screen
        -- Promptbox 
        s.promptbox = awful.widget.prompt()
        -- Taglist
        s.taglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_info.buttons,
            widget_template = taglist_info.template
        }
        -- Tasklist
        s.tasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_info.buttons,
            layout   = {
                layout  = wibox.layout.fixed.horizontal
            },
            widget_template = tasklist_info.template
        }
        -- Current layout indicator
        s.layoutbox = awful.widget.layoutbox(s)
        s.layoutbox:buttons(layoutbox_buttons)
        -- Wibar on top that will display previous widgets
        s.wibox = awful.wibar {
            position = "top",
            ontop = true,
            screen = s,
            height = 30
        }
        -- }}}

        -- Add widgets to the wibox
        s.wibox:setup {
            {
                -- Left widgets
                {
                    create_pill(launchermenu, "#00000090", true),
                    create_pill(s.taglist, theme.border_marked, true),
                    s.promptbox,

                    layout = wibox.layout.fixed.horizontal,
                },
                -- Middle widget
                create_pill(s.tasklist, "#00000090", true), 
                -- Right widgets
                {
                    create_pill(keyboardlayout, "#00000090", true),
                    create_pill(systray, "#00000090", true),
                    create_pill(textclock, "#00000090", true),
                    create_pill(s.layoutbox, "#00000090"),

                    layout = wibox.layout.fixed.horizontal,
                },

                layout = wibox.layout.align.horizontal,
            },
            widget = wibox.container.margin,

            top = 2,
            bottom = 2,
            left = 4,
            right = 4
        }
    end
)
