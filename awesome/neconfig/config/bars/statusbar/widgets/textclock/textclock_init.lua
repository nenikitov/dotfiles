-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')


local function get_textclock(bar_info)
    -- Get style from the theme
    local style = bar_info.widgets.clock
    local font = beautiful.user_vars_theme.general.font
    local font_size = beautiful.user_vars_theme.general.text_size


    -- Construct 2 separate widgets for date and time
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

    -- Construct the final widget
    local final_widget = wibox.widget {
        layout = wibox.layout.flex.vertical,
        fill_space = true,

        top_time,
        bottom_time
    }

    return final_widget
end


return setmetatable(
    {},
    {  __call = function(_, ...) return get_textclock(...) end }
)
