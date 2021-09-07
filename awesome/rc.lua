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


local user_vars = require('neconfig.config.user.user_vars')


-- Load the theme
beautiful.init(user_vars.desktop.theme_path)

-- TODO remove this later
beautiful.bg_normal = '#00000000'
beautiful.bg_focus = '#00000010'

require('neconfig.config.main.wallpaper')


require('neconfig.config.main.tag')


-- TODO move to separate module?
local global_keys = require('neconfig.config.globalbinds.keys')
local global_tagbinds = require('neconfig.config.globalbinds.tagbinds')
global_keys = global_tagbinds(global_keys())
local global_buttons = require('neconfig.config.globalbinds.buttons')
-- Load key binds
root.keys(global_keys)
root.buttons(global_buttons)


-- Init layouts
awful.layout.layouts = user_vars.desktop.layouts


-- Set the terminal for applications that require it
menubar.utils.terminal = user_vars.apps.default_apps.terminal

-- Init wibar
require('neconfig.config.bars.statusbar.init')


-- TODO move to separate module?
local rules = require('neconfig.config.client.rules')
local client_buttons = require('neconfig.config.client.buttons')
local client_keys = require('neconfig.config.client.keys')
awful.rules.rules = rules(client_keys(), client_buttons())
require('neconfig.config.client.signals')

-- Autostart
require('neconfig.config.main.autostart')
