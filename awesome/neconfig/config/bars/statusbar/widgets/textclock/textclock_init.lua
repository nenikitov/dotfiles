-- Load libraries
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')


local function get_textclock(bar_info)
    -- Get style from the theme
    local style = bar_info.widgets.clock
    local font = beautiful.user_vars_theme.general.font
    local font_size = beautiful.user_vars_theme.general.text_size


    -- Construct 2 separate clock widgets
    local primary_time = wibox.widget {
        widget = wibox.widget.textclock,

        format = '<span font_weight="' .. style.primary_weight .. '">' .. user_vars_conf.statusbar.widgets.clock.primary_format .. '</span>',
        font = font .. ' ' .. (font_size * style.primary_size),
        align = 'center'
    }
    local secondary_time = wibox.widget {
        widget = wibox.widget.textclock,

        format = '<span font_weight="' .. style.secondary_weight .. '">' .. user_vars_conf.statusbar.widgets.clock.secondary_format .. '</span>',
        font = font .. ' ' .. (font_size * style.secondary_size),
        align = 'center'
    }

    -- Construct the final widget
    if (style.direction == 'vertical')
    then
        local widget = wibox.widget {
            layout = wibox.layout.ratio.vertical,
            fill_space = true,

            primary_time,
            secondary_time,
        }
        widget:set_ratio(2, 0.5 * style.secondary_size)
        return widget
    else
        return wibox.widget {
            layout = wibox.layout.align.horizontal,
            fill_space = true,

            primary_time,
            secondary_time
        }
    end
end


return setmetatable(
    {},
    {  __call = function(_, ...) return get_textclock(...) end }
)
