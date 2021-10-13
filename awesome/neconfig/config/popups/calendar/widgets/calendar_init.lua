-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')


-- Get style variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size
local popup_style = beautiful.user_vars_theme.popup
local calendar_style_vars = popup_style.popups.calendar
local function calendar_style(contents, flag, date)
    -- Get properties
    local props = calendar_style_vars[flag] or calendar_style_vars['other']

    -- Get if the current day is a weekend
    local date_transformed = {
        year = date.year,
        month = (date.month or 1),
        day = (date.day or 1)
    }
    local weekday = tonumber(os.date('%w', os.time(date_transformed)))
    local is_weekend = (weekday == 0 or weekday == 6) and (flag ~= 'weekday')
    if (is_weekend and flag ~= 'focus')
    then
        props = calendar_style_vars['weekend']
    end

    -- Apply text properties if contents is textbox
    if (contents.get_text and contents.set_markup)
    then
        contents:set_markup(
            '<span font_weight="' .. props.font_weight
            .. '" foreground="' .. props.foreground_color .. '">'
            .. contents:get_text() .. '</span>'
        )
        contents.font = font .. ' ' .. (font_size * props.font_size)
    end

    -- Return widget
    local final_widget = wibox.widget {
        {
            {
                contents,
    
                widget = wibox.container.place
            },

            margins = math.floor(calendar_style_vars.container.element_padding),

            widget = wibox.container.margin
        },

        bg = props.background_color,
        shape = r_rect(props.corner_radius),
        shape_clip = true,

        widget = wibox.container.background
    }
    if (is_weekend and flag == 'focus')
    then
        return wibox.widget {
            final_widget,

            bg = calendar_style_vars['weekend'].background_color,
            shape = r_rect(calendar_style_vars['weekend'].corner_radius),

            widget = wibox.container.background
        }
    else
        return final_widget
    end
end

return wibox.widget {
    {
        date = os.date('*t'),
        font = font .. ' ' .. font_size,
        spacing = calendar_style_vars.container.spacing,
        week_numbers = false,
        start_sunday = false,
        long_weekdays = true,
        fn_embed = calendar_style,
        widget = wibox.widget.calendar.month
    },

    widget = wibox.container.place
}
