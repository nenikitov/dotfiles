-- Ensure that LuaRocks is installed
pcall(require, 'luarocks.loader')

-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local menubar = require('menubar')
-- Load custom modules
local user_apps = require('neconfig.user.config.user_apps')


-- Init error handling
require('neconfig.config.main.main_error_handling')


-- TODO implement if statement to enable / disable from config
require('awful.autofocus')


-- Load the theme
beautiful.init(os.getenv('HOME') .. '/.config/awesome/neconfig/theme/theme.lua')
require('neconfig.config.main.main_wallpaper')


-- Generate tags
require('neconfig.config.main.main_tag')

-- Init layouts
require('neconfig.config.main.main_layout')

-- Load key binds
require('neconfig.config.main.main_global_binds')

-- Set the terminal for applications that require it
menubar.utils.terminal = user_apps.default_apps.terminal

-- Init clients
require('neconfig.config.client.client_init')

-- Init wibar
require('neconfig.config.widgets.statusbar.statusbar_init')

-- Autostart applications
require('neconfig.config.main.main_autostart')
