-- Ensure that LuaRocks is installed
pcall(require, "luarocks.loader")

-- {{{ Load libraries
-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Load widget and layout library
local wibox = require("wibox")
-- Load theme handling library
local beautiful = require("beautiful")
-- Load notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Error handling module
require("main.error-handling")
-- }}}

-- RC is a global scope for the modules
rc = {}
-- Load user variables
rc.uservars = require("main.user-vars")
-- Set global variables
modkey = rc.uservars.modkey
terminal = rc.uservars.terminal
editor = rc.uservars.editor
editor_cmd = terminal .. " -e " .. editor

-- Load theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme/netheme/theme.lua")

-- {{{ Load custom modules
-- Main modules
local modmain = {
    layouts = require("main.layouts"),
    tags = require("main.tags"),
    menu = require("main.menu"),
    rules = require("main.rules")
}
-- Bind modules
local modbind = {
    globalbuttons = require("bind.globalbuttons"),
    clientbuttons = require("bind.clientbuttons"),
    globalkeys = require("bind.globalkeys"),
    bindtotags = require("bind.bindtotags"),
    clientkeys = require("bind.clientkeys")
}
-- }}}

-- Set more global variables
rc.tags = modmain.tags
rc.globalkeys = modbind.bindtotags(modbind.globalkeys())

-- Load menu
rc.menu = awful.menu({ items = modmain.menu })
rc.launcher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = rc.menu
})

-- Init layouts
awful.layout.layouts = modmain.layouts

-- Set the terminal for applications that require it
menubar.utils.terminal = rc.uservars.terminal

-- Init wibar
require("deco.statusbar")

-- Load key binds
root.keys(rc.globalkeys)
root.buttons(modbind.globalbuttons())

-- Set rules
awful.rules.rules = modmain.rules(modbind.clientkeys(), modbind.clientbuttons())

-- Set signals
require("main.signals")

-- Autostart
require("main.autostart")
