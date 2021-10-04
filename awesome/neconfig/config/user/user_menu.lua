-- Load libraries
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Get variables
local terminal = user_vars_conf.apps.default_apps.terminal


-- Customize this
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
