-- Load libraries
local wibox = require('wibox')

-- Construct widget
local sys_tools_button = wibox.widget {
    text = '\u{f552}',
    align = 'center',
    valign = 'center',

    widget = wibox.widget.textbox
}

return sys_tools_button
