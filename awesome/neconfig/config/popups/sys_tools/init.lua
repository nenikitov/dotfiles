-- Load libraries
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.popup_utils')


-- Create widgets
local test_sub_widget = require('neconfig.config.popups.sys_tools.widgets.test_init')
local tray_sub_widget = require('neconfig.config.popups.sys_tools.widgets.sys_tray_init')()
tray_sub_widget.base_size = 24
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
            test_sub_widget,
            tray_sub_widget
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
