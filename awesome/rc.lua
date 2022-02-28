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

local gears = require('gears')
local cairo = require('lgi').cairo
local user_look_titlebar_widgets = require('neconfig.user.look.widgets.user_look_titlebar_widgets')
local function generate_titlebar_icon(icon_path, shape_props, size)
    -- Draw background
    local img = cairo.ImageSurface(cairo.Format.ARGB32, size, size)
    local cr = cairo.Context(img)

    cr:set_source(gears.color('#00000000'))
    cr:paint()


    -- Draw shape
    local bw = shape_props.border_width
    cr:translate(bw, bw)
    shape_props.shape(cr, size - 2 * bw, size - 2 * bw)
    cr:set_source(gears.color(shape_props.shape_bg))
    cr:fill_preserve()
    cr:set_source(gears.color(shape_props.border_color))
    cr:set_line_width(bw)
    cr:stroke()

    -- Draw icon
    local icon = gears.color.recolor_image(icon_path)

    return img
end
beautiful.titlebar_close_button_focus = generate_titlebar_icon(
    '/home/nenikitov/.config/awesome/neconfig/graphics/icons/titlebar/close.svg',
    user_look_titlebar_widgets.buttons.close.inactive.focus,
    24
)