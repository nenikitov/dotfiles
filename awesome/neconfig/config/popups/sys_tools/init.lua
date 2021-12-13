-- Load libraries
local wibox = require('wibox')
-- Load custom modules
local popup_utils = require('neconfig.config.utils.popup_utils')
local widget_utils = require('neconfig.config.utils.widget_utils')


local vol_sub = require('neconfig.config.popups.sys_tools.widgets.vol_display_init')

local net_sub = require('neconfig.config.popups.sys_tools.widgets.net_display_init')
local bat_sub = require('neconfig.config.popups.sys_tools.widgets.bat_display_init')
local mem_sub = require('neconfig.config.popups.sys_tools.widgets.mem_display_init')
local sys_sub = require('neconfig.config.popups.sys_tools.widgets.sys_display_init')
local cpu_sub = require('neconfig.config.popups.sys_tools.widgets.cpu_display_init')

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

    popup_utils.add_custom_popup {
        name = 'sys_tools',
        widgets = {
            vol_sub,
            separator,
            net_sub,
            bat_sub,
            mem_sub,
            sys_sub,
            cpu_sub,
            separator,
            tray_sub,
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
