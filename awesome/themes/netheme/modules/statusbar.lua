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


function theme.at_screen_connect(s)
    -- Add widgets to the wibox
    s.wibox:setup {
        -- Left widgets
        {
            launchermenu,
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
