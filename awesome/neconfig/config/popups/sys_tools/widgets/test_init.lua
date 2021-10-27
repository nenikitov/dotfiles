-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')

-- Get style variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size
local theme_font_weight = beautiful.user_vars_theme.popup.popups.calendar.date_time_header.date_font_weight
local theme_font_size = beautiful.user_vars_theme.popup.popups.calendar.date_time_header.date_font_size

return wibox.widget {
    format = '<span font_weight="' .. theme_font_weight ..'"> %A, %Y-%m-%d </span>',
    font = font .. ' ' .. (font_size * theme_font_size),
    align = 'center',

    widget = wibox.widget.textclock
}
