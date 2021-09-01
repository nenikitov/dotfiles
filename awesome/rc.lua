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


-- Load the theme MODIFY THIS LAYER
beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')
-- beautiful.init(user_vars.desktop.theme_path)


require('config.main.tag')
-- Bind modules
local modbind = {
    global_buttons = require('config.globalbinds.buttons'),
    global_keys = require('config.globalbinds.keys'),
    global_tagbinds = require('config.globalbinds.tagbinds'),    
    client_buttons = require('config.client.buttons'),
    client_keys = require('config.client.keys')
}

-- Set more global variables
local global_keys = modbind.global_tagbinds(modbind.global_keys())

-- Init layouts
awful.layout.layouts = user_vars.desktop.layouts

-- Set the terminal for applications that require it
menubar.utils.terminal = user_vars.apps.default_apps.terminal

-- Init wibar
require("modules.deco.statusbar")

-- Load key binds
root.keys(global_keys)
root.buttons(modbind.global_buttons())

-- Set rules
local rules = require('config.client.rules')
awful.rules.rules = rules(modbind.client_keys(), modbind.client_buttons())

-- Set signals
require('config.client.signals')

-- Autostart
require('config.main.autostart')
