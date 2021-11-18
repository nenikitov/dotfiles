-- Load libraries
local vicious = require('vicious')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')
local icons = require('neconfig.config.utils.icons')

local battery = create_monitor_widget(
    vicious.widgets.bat, 10,
    '$1$2', icons.battery0, 'BAT0'
)

local remaining = create_monitor_widget(
    vicious.widgets.bat, 10,
    '$3', icons.hourglass
)

return wibox.widget {
    battery,
    remaining,

    layout = wibox.layout.flex.horizontal
}
