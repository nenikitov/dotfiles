-- Load libraries
local wibox = require('wibox')

-- Construct widget
return wibox.widget {
    text = '\u{f552}',
    align = 'center',
    valign = 'center',

    widget = wibox.widget.textbox
}
