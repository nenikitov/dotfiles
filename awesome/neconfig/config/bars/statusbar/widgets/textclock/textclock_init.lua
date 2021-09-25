-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')
local textclock_buttons = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_buttons')()
-- Get variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size


local function get_textclock(bar_info)
    -- Get style from the theme
    local style = bar_info.widgets.clock


    -- Generate 2 separate widgets for date and time
    local top_time = wibox.widget {
        widget = wibox.widget.textclock,

        format = '<span font_weight="' .. style.top_weight .. '">' .. user_vars_conf.statusbar.widgets.clock.top_format .. '</span>',
        font = font .. ' ' .. (font_size * style.top_size),
        align = 'center'
    }
    local bottom_time = wibox.widget {
        widget = wibox.widget.textclock,

        format = '<span font_weight="' .. style.bottom_weight .. '">' .. user_vars_conf.statusbar.widgets.clock.bottom_format .. '</span>',
        font = font .. ' ' .. (font_size * style.bottom_size),
        align = 'center'
    }

    -- Construct the layered widget
    local final_widget =  wibox.widget {
        layout = wibox.layout.flex.vertical,
        fill_space = true,

        top_time,
        bottom_time
    }

    local calendar = require('neconfig.config.bars.statusbar.widgets.textclock.calendar')
    local cal_popup = awful.popup {
        placement = awful.placement.top,
        ontop = true,
        widget = calendar,
        visible = false
    }

    final_widget:connect_signal('mouse::enter', function (s)
        cal_popup.visible = true
    end)
    final_widget:connect_signal('mouse::leave', function (s)
        cal_popup.visible = false
    end)

    return final_widget
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_textclock(...) end }
)
