-- Load libraries
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local beautiful = require('beautiful')
-- Load custom modules
local user_vars = require('neconfig.config.user.user_vars')

-- Get variables
local terminal = user_vars.apps.default_apps.terminal


-- Customize this
-- █▀█ █ █ █ █▀▀ █▄▀   █▀▄▀█ █▀▀ █▄ █ █ █
-- ▀▀█ █▄█ █ █▄▄ █ █   █ ▀ █ ██▄ █ ▀█ █▄█
-- 'Awesome' submenu
local menu_root_awesome = {
    { 'Hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { 'Restart', awesome.restart },
    { 'Quit', function() awesome.quit() end },
}

-- 'Root' menu
local menu_root = {
    { 'Awesome', menu_root_awesome, beautiful.awesome_icon },
    { 'Terminal', terminal }
}

return awful.menu({ items = menu_root })
