-- Load libraries
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')


-- Construct system tools button widget
return wibox.widget {
    widget = wibox.widget.textbox,

    text = icons.toolbox,
    align = 'center',
    valign = 'center'
}
