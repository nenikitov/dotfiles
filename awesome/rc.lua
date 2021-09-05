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
require('config.main.error_handling')


local user_vars = require('config.user.user_vars')


-- Load the theme
beautiful.init(user_vars.desktop.theme_path)


require('config.main.wallpaper')


require('config.main.tag')


-- TODO move to separate module?
local global_keys = require('config.globalbinds.keys')
local global_tagbinds = require('config.globalbinds.tagbinds')
global_keys = global_tagbinds(global_keys())
local global_buttons = require('config.globalbinds.buttons')
-- Load key binds
root.keys(global_keys)
root.buttons(global_buttons)


-- Init layouts
awful.layout.layouts = user_vars.desktop.layouts


-- Set the terminal for applications that require it
menubar.utils.terminal = user_vars.apps.default_apps.terminal

-- Init wibar
require('config.bars.statusbar.init')


-- TODO move to separate module?
local rules = require('config.client.rules')
local client_buttons = require('config.client.buttons')
local client_keys = require('config.client.keys')
awful.rules.rules = rules(client_keys(), client_buttons())
require('config.client.signals')

-- Autostart
require('config.main.autostart')
