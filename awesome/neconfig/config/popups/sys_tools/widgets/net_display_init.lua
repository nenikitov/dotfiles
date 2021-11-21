-- Load libraries
local vicious = require('vicious')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')
local icons = require('neconfig.config.utils.icons')

local download = create_vicious_widget(
    vicious.widgets.net, 1,
    '${enp0s31f6 down_mb}', icons.download
)

local upload = create_vicious_widget(
    vicious.widgets.net, 1,
    '${enp0s31f6 up_mb}', icons.upload
)

return wibox.widget {
    download,
    upload,

    layout = wibox.layout.flex.horizontal
}
