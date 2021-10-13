-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')

-- Get style variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size

return wibox.widget {
    format = '<span font_weight="500"> %A, %Y-%m-%d </span>',
    font = font .. ' ' .. (font_size * 1.1),
    align = 'center',

    widget = wibox.widget.textclock
}
