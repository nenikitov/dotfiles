-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')

-- Get style variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size

return wibox.widget {
    format = '%Y-%m-%d',
    font = font .. ' ' .. (font_size * 1.25),
    align = 'center',

    widget = wibox.widget.textclock
}
