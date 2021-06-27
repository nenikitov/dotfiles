-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps 
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Error handling
require("main.error-handling")

rc = {}
rc.uservars = require("main.user-vars")
modkey = rc.uservars.modkey
terminal = rc.uservars.terminal
editor = rc.uservars.editor
editor_cmd = terminal .. " -e " .. editor

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- Load custom modules
local modmain = {
	layouts = require("main.layouts"),
	tags = require("main.tags"),
	menu = require("main.menu"),
	rules = require("main.rules")
}
local modbind = {
	globalbuttons = require("bind.globalbuttons"),
	clientbuttons = require("bind.clientbuttons"),
	globalkeys = require("bind.globalkeys"),
	bindtotags = require("bind.bindtotags"),
	clientkeys = require("bind.clientkeys")
}

rc.tags = modmain.tags
rc.globalkeys = modbind.bindtotags(modbind.globalkeys())

-- Menu
rc.menu = awful.menu({ items = modmain.menu })
rc.launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = rc.menu
})

-- Table of layouts
awful.layout.layouts = modmain.layouts
-- Set the terminal for applications that require it
menubar.utils.terminal = rc.uservars.terminal

-- Wibar
require("deco.statusbar")

-- Set keys
root.keys(rc.globalkeys)
root.buttons(modbind.globalbuttons())

-- Rules
awful.rules.rules = modmain.rules(modbind.clientkeys(), modbind.clientbuttons())

-- Signals
require("main.signals")

-- Autostart
awful.spawn.with_shell("picom --xrender-sync-fence")
awful.spawn.with_shell("nitrogen --restore")
