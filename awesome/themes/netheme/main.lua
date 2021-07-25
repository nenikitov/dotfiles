theme_assets = require("beautiful.theme_assets")
xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
themes_path = gfs.get_themes_dir()

local awful = require("awful")
awful.util = require("awful.util")
config_path = awful.util.getdir("config")
netheme_path = config_path .. "/themes/netheme/"
theme = {}

-- {{{ Load cutom modules
palette = require("themes.netheme.modules.palette")
require("themes.netheme.modules.elements")
require("themes.netheme.modules.icons")
-- }}}

theme.icon_theme = nil
theme.wallpaper = netheme_path .. "wallpaper.png"

return theme
