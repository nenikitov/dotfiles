-- Load libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')
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
    return wibox.widget {
        top_time,
        bottom_time,
        layout = wibox.layout.flex.vertical,
        fill_space = true
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_textclock(...) end }
)
