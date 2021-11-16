-- Load libraries
local vicious = require('vicious')
-- Load custom modules
require('neconfig.config.utils.widget_utils')
local icons = require('neconfig.config.utils.icons')

return create_monitor_widget(
    vicious.widgets.mem, 1,
    '$2MiB / $3MiB', icons.ram_module
)
