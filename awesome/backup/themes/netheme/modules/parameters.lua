-- Custom theme properties
theme.rounding_buttons = 6
theme.rounding_clients = 10
theme.pillcolor = palette.fg_text.normal

-- Font
theme.font = "Jost* 12"

-- Decorations
theme.useless_gap = dpi(5)
theme.border_width = dpi(1)

-- {{{ Generic colors
-- Foreground colors
theme.fg_normal = palette.fg_text.normal
theme.fg_focus = palette.fg_text.active
theme.fg_urgent = palette.fg_text.active
theme.fg_minimize = palette.fg_text.active
-- Background colors
theme.bg_normal = palette.bg_neutral.normal .. "e6"
theme.bg_focus = palette.bg_primary.active .. "f0"
theme.bg_urgent = "#800000ff"
theme.bg_minimize = palette.bg_neutral.active
-- Borders
theme.border_normal = theme.bg_normal
theme.border_focus = theme.bg_focus
-- }}}

-- {{{ More specific colors
-- Menu
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width = dpi(200)

-- Notifications
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Systray
theme.bg_systray = theme.bg_normal

-- Taglist
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]

-- Tasklist
theme.tasklist_bg_focus = palette.fg_text.dull .. "a0"

-- Titlebar
-- titlebar_[bg|fg]_[normal|focus]

-- Tooltip
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]

-- Prompt
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]

-- Hotkeys
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- }}}