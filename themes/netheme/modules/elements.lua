-- Font
theme.font          = "sans 12"

-- Foreground colors
theme.fg_normal     = palette.fg_text.normal
theme.fg_focus      = palette.fg_text.active
theme.fg_urgent     = palette.fg_text.active
theme.fg_minimize   = palette.fg_text.active
-- Background colors
theme.bg_normal     = palette.bg_blue.dull .. "f2"
theme.bg_focus      = palette.bg_red.active
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = palette.bg_variation.active
theme.bg_systray    = theme.bg_normal
-- Borders
theme.border_width  = dpi(1)
theme.border_normal = palette.bg_blue.dull
theme.border_focus  = palette.bg_red.active
theme.border_marked = "#91231c"

-- Gap
theme.useless_gap   = dpi(5)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
