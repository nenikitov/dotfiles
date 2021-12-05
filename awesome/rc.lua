-- Ensure that LuaRocks is installed
pcall(require,'luarocks.loader')
-- Load libraries
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')

-- Init error handling
require('neconfig.config.main.error_handling')

local user_desktop = require('neconfig.config.user.user_desktop')
local user_apps = require('neconfig.config.user.user_apps')


-- Load the theme
beautiful.init(user_desktop.theme_path)

require('neconfig.config.main.wallpaper')


require('neconfig.config.main.tag')


-- TODO move to separate module?
local global_keys = require('neconfig.config.global_binds.global_keys')()
local global_tag_binds = require('neconfig.config.global_binds.global_tag_binds')
global_keys = global_tag_binds(global_keys)
local global_buttons = require('neconfig.config.global_binds.global_buttons')()
-- Load key binds
root.keys(global_keys)
root.buttons(global_buttons)


-- Init layouts
awful.layout.layouts = user_desktop.layouts


-- Set the terminal for applications that require it
menubar.utils.terminal = user_apps.default_apps.terminal

-- Init wibar
require('neconfig.config.bars.statusbar.init')


-- TODO move to separate module?
local rules = require('neconfig.config.client.client_rules')
local client_buttons = require('neconfig.config.client.client_buttons')
local client_keys = require('neconfig.config.client.client_keys')
awful.rules.rules = rules(client_keys(), client_buttons())
require('neconfig.config.client.client_signals')

-- Autostart
require('neconfig.config.main.autostart')
