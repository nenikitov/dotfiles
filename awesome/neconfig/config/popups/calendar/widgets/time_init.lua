-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')

-- Get style variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size

return wibox.widget {
    format = '<span font_weight="500"> %H:%M:%S </span>',
    font = font .. ' ' .. (font_size * 3),
    align = 'center',
    refresh = 1,

    widget = wibox.widget.textclock
}
