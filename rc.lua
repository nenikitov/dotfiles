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

-- Load custom modules
local modmain = {
	uservars = require("main.user-vars"),
	layouts = require("main.layouts"),
	tags = require("main.tags"),
	menu = require("main.menu"),
	rules = require("main.rules")
}
rc.uservars = modmain.uservars
rc.tags = modmain.tags

local modbind = {
	globalbuttons = require("bind.globalbuttons"),
	clientbuttons = require("bind.clientbuttons"),
	globalkeys = require("bind.globalkeys"),
	bindtotags = require("bind.bindtotags"),
	clientkeys = require("bind.clientkeys")
}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/nenikitov/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.

rc.globalkeys = modbind.bindtotags(modbind.globalkeys())

terminal = rc.uservars.terminal
editor = rc.uservars.editor
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = rc.uservars.modkey

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = modmain.layouts

-- Menu
rc.menu = awful.menu({ items = modmain.menu })
rc.launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = rc.menu
})
menubar.utils.terminal = rc.uservars.terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
require("deco.statusbar")
-- }}}

root.buttons(modbind.globalbuttons())

-- {{{ Key bindings
globalkeys = rc.globalkeys

clientkeys = modbind.clientkeys()

clientbuttons = modbind.clientbuttons()

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = modmain.rules(clientkeys, clientbuttons)

-- Signals
require("main.signals")

-- Autostart
awful.spawn.with_shell("picom --xrender-sync-fence")
awful.spawn.with_shell("nitrogen --restore")
