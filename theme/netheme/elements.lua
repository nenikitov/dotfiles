-- {{{ Load libraries and modules
-- Standard Awesome libraries
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- Custom module for the color palette
local palette = require("theme.netheme.palette")
-- }}}

-- {{{ Theme setup
-- Font
theme.font          = "sans 12"
-- Foreground colors
theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"
-- Background colors
theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal
-- Borders
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"
-- Gap
theme.useless_gap   = dpi(5)
-- }}}
