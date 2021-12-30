-- Load libraries
local beautiful = require('beautiful')
local wibox = require('wibox')

-- Get variables
local font = beautiful.user_vars_theme.general.font
local font_height = beautiful.get_font_height(font)


---Construct clock widget
---@param args table Arguments with different settings
---@return table textclock_widget Widget
local function get_textclock(args)
    -- Reference to arguments and default values
    local direction = args.direction or 'vertical'
    local primary_format = args.primary_format or '%H:%M'
    local primary_size = args.primary_size or 1.0
    local primary_weight = args.primary_weight or '600'
    local secondary_format = args.secondary_format or '%a %Y-%m-%d'
    local secondary_size = args.secondary_size or 0.75
    local secondary_weight = args.secondary_weight or 'normal'

    -- Construct 2 separate clock widgets
    local primary_time = wibox.widget {
        widget = wibox.widget.textclock,

        format = '<span font_weight="' .. primary_weight .. '">' .. primary_format .. '</span>',
        font = font .. ' ' .. (0.5 * font_height * primary_size),
        align = 'center'
    }
    local secondary_time = wibox.widget {
        widget = wibox.widget.textclock,

        format = '<span font_weight="' .. secondary_weight .. '">' .. secondary_format .. '</span>',
        font = font .. ' ' .. (0.5 * font_height * secondary_size),
        align = 'center'
    }

    -- Construct the final widget
    if (direction == 'vertical')
    then
        local widget = wibox.widget {
            primary_time,
            secondary_time,

            layout = wibox.layout.ratio.vertical,

            fill_space = true
        }
        widget:set_ratio(2, 0.5 * secondary_size)
        return widget
    else
        return wibox.widget {
            primary_time,
            secondary_time,

            layout = wibox.layout.fixed.horizontal,

            spacing = font_height / 8,
        }
    end
end


return setmetatable(
    {},
    {  __call = function(_, ...) return get_textclock(...) end }
)
