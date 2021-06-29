theme_assets = require("beautiful.theme_assets")
xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
themes_path = gfs.get_themes_dir()

theme = {}

-- {{{ Load cutom modules
require("theme.netheme.modules.elements")
require("theme.netheme.modules.taglist")
require("theme.netheme.modules.menu")
require("theme.netheme.modules.titlebar")
require("theme.netheme.modules.layout")
-- }}}

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

theme.icon_theme = nil
-- theme.wallpaper = themes_path .. "default/background.png"

return theme
