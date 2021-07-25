-- {{{ Load modules
local gfs = require("gears.filesystem")
local awful = require("awful")
-- }}}

-- {{{ Initialize global variables
theme_assets = require("beautiful.theme_assets")
xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi
themes_path = gfs.get_themes_dir()
awful.util = require("awful.util")
config_path = awful.util.getdir("config")
netheme_path = config_path .. "/themes/netheme/"
-- Here all the theme info will be stored
theme = {}
-- }}}

-- {{{ Load cutom modules
palette = require("themes.netheme.modules.palette")
require("themes.netheme.modules.parameters")
require("themes.netheme.modules.graphics")
require("themes.netheme.modules.elements")
-- }}}

return theme
