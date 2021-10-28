-- Load libraries
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.popup_utils')


-- Create widgets
local calendar_sub_widget = require('neconfig.config.popups.calendar.widgets.calendar_init')
local time_sub_widget = require('neconfig.config.popups.calendar.widgets.time_init')
local date_sub_widget = require('neconfig.config.popups.calendar.widgets.date_init')
local separator = wibox.widget.separator {
    forced_width = 2,
    forced_height = 2
}

local function get_popup_calendar(args)
    local position = args.position
    local screen = args.screen
    local info_table = args.info_table
    local toggle_visibility_widget = args.toggle_visibility_widget

    add_custom_popup {
        name = 'calendar',
        widgets = {
            time_sub_widget,
            date_sub_widget,
            separator,
            calendar_sub_widget,
        },
        tooltip = 'Open calendar',
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
    {  __call = function(_, ...) return get_popup_calendar(...) end }
)
