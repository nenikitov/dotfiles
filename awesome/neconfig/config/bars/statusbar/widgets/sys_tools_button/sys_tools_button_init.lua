-- Load libraries
local wibox = require('wibox')

-- Get variables
local icons = require('neconfig.config.utils.icons')

-- Construct widget
return wibox.widget {
    text = icons.toolbox,
    align = 'center',
    valign = 'center',

    widget = wibox.widget.textbox
}
