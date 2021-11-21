-- Load libraries
local vicious = require('vicious')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')
local icons = require('neconfig.config.utils.icons')

local uptime = create_vicious_widget(
    vicious.widgets.uptime, 60,
    '$2:$3', icons.clock
)

local updates = create_vicious_widget(
    vicious.widgets.pkg, 120,
    '$1', icons.update, 'Arch'
)

return wibox.widget {
    uptime,
    updates,

    layout = wibox.layout.flex.horizontal
}
