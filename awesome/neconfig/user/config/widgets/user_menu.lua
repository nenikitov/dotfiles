-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
-- Load custom modules
local user_apps = require('neconfig.user.config.user_apps')

-- Get variables
local terminal = user_apps.default_apps.terminal


-- █▀█ █ █ █ █▀▀ █▄▀   █▀▄▀█ █▀▀ █▄ █ █ █
-- ▀▀█ █▄█ █ █▄▄ █ █   █ ▀ █ ██▄ █ ▀█ █▄█
-- 'Awesome' submenu
local menu_root_awesome = {
    -- Show hotkeys
    {
        text = 'Hotkeys',
        cmd = function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    -- Restart Awesome WM
    {
        text = 'Restart WM',
        cmd = awesome.restart
    },
    -- Quit Awesome WM
    {
        text = 'Quit WM',
        cmd = function()
            awesome.quit()
        end
    },
}

-- Root menu
local menu_root = {
    -- Awesome submenu
    {
        text = 'Awesome',
        cmd = menu_root_awesome,
        icon = beautiful.awesome_icon
    },
    -- Open terminal
    {
        text = 'Terminal',
        cmd = terminal
    }
}

return awful.menu({ items = menu_root })
