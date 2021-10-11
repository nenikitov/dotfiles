-- Load custom modules
require('neconfig.config.utils.popup_utils')


-- Create widgets
local calendar_sub_widget = require('neconfig.config.popups.calendar.widgets.calendar_init')

local function get_popup_calendar(args)
    local position = args.position
    local style = args.style
    local screen = args.screen
    local info_table = args.info_table

    add_custom_popup {
        name = 'calendar',
        widgets = {
            calendar_sub_widget,
        },
        position = position,
        size = 'fit',
        style = style,
        screen = screen,
        info_table = info_table,
    }
end


return setmetatable(
    {},
    {  __call = function(_, ...) return get_popup_calendar(...) end }
)
