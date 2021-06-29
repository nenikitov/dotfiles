theme_assets = require("beautiful.theme_assets")
xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
themes_path = gfs.get_themes_dir()

local awful = require("awful")
awful.util = require("awful.util")
netheme_path = awful.util.getdir("config") .. "/themes/netheme/"

theme = {}

-- {{{ Load cutom modules
palette = require("themes.netheme.modules.palette")
require("themes.netheme.modules.elements")
require("themes.netheme.modules.taglist")
require("themes.netheme.modules.menu")
require("themes.netheme.modules.titlebar")
require("themes.netheme.modules.layout")
-- }}}

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

theme.icon_theme = nil
-- theme.wallpaper = themes_path .. "default/background.png"

return theme
