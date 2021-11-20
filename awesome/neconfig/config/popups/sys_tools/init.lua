-- Load libraries
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.popup_utils')


-- Create widgets
-- TODO
    -- Network - download, upload
    -- Power - status, remaining
    -- Usage - CPU, ?
    -- Memory - RAM, Swap
    -- Uptime
local battery_display_sub = require('neconfig.config.popups.sys_tools.widgets.battery_display_init')
local system_display_sub = require('neconfig.config.popups.sys_tools.widgets.system_display_init')
local net_display_sub = require('neconfig.config.popups.sys_tools.widgets.net_display_init')
local tray_sub = require('neconfig.config.popups.sys_tools.widgets.sys_tray_init')()
tray_sub.base_size = 24
tray_sub.forced_width = 240
local separator = wibox.widget.separator {
    forced_width = 2,
    forced_height = 2
}

local function get_popup_sys_tools(args)
    local position = args.position
    local screen = args.screen
    local info_table = args.info_table
    local toggle_visibility_widget = args.toggle_visibility_widget

    add_custom_popup {
        name = 'sys_tools',
        widgets = {
            tray_sub,
            battery_display_sub,
            system_display_sub,
            net_display_sub
        },
        tooltip = 'Open system tools',
        direction = 'vertical',
        position_type = 'attach',
        position_args = position,
        size = 'fit',
        toggle_visibility_widget = toggle_visibility_widget,
        screen = screen,
        info_table = info_table,
    }
end


return setmetatable(
    {},
    {  __call = function(_, ...) return get_popup_sys_tools(...) end }
)
