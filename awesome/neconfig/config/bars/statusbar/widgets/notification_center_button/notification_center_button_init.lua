-- Load libraries
local wibox = require('wibox')

-- Construct widget
local notification_center_button = wibox.widget {
    text = '\u{f27a}',
    align = 'center',
    valign = 'center',

    widget = wibox.widget.textbox
}

return notification_center_button
