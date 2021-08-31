-- Standard Awesome libraries
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful = require("beautiful")

-- Create a launcher widget and a main menu
-- "Awesome" submenu
local menuawesome = {
    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
}

-- Root menu
local menu = {
    { "Awesome", menuawesome, beautiful.awesome_icon },
    { "Terminal", terminal }
}

return menu
