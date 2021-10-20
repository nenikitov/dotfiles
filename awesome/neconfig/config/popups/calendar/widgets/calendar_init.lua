-- Load modules
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')


-- Get style variables
local font = beautiful.user_vars_theme.general.font
local font_size = beautiful.user_vars_theme.general.text_size
local popup_style = beautiful.user_vars_theme.popup
local function get_element_style_var(flag, element)
    local calendar_style_vars = popup_style.popups.calendar
    if (not calendar_style_vars[flag])
    then
        return calendar_style_vars['other'][element]
    else
        return calendar_style_vars[flag][element] or calendar_style_vars['other'][element]
    end
end
local function calendar_style(contents, flag, date)
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
        flag = 'weekend'
    end

    -- Apply text properties if contents is textbox
    if (contents.get_text and contents.set_markup)
    then
        contents:set_markup(
            '<span font_weight="' .. get_element_style_var(flag, 'font_weight')
            .. '" font_style="' .. get_element_style_var(flag, 'font_style')
            .. '" foreground="' .. get_element_style_var(flag, 'foreground_color') .. '">'
            .. contents:get_text() .. '</span>'
        )
        contents.font = font .. ' ' .. (font_size * get_element_style_var(flag, 'font_size'))
    end

    -- Return widget
    local final_widget = wibox.widget {
        {
            {
                contents,

                widget = wibox.container.place
            },

            margins = math.floor(popup_style.popups.calendar.container.element_padding),

            widget = wibox.container.margin
        },

        bg = get_element_style_var(flag, 'background_color'),
        shape = r_rect(get_element_style_var(flag, 'corner_radius')),
        shape_clip = true,

        widget = wibox.container.background
    }
    if (is_weekend and flag == 'focus')
    then
        return wibox.widget {
            final_widget,

            bg = get_element_style_var('weekend', 'background_color'),
            shape = r_rect(get_element_style_var('weekend', 'corner_radius')),

            widget = wibox.container.background
        }
    else
        return final_widget
    end
end
-- Generate calendar widget
local calendar = wibox.widget {
    date = os.date('*t'),
    font = font .. ' ' .. font_size,
    spacing = popup_style.popups.calendar.container.spacing,
    week_numbers = false,
    start_sunday = false,
    long_weekdays = true,
    fn_embed = calendar_style,
    widget = wibox.widget.calendar.month
}
local final_widget = wibox.widget {
    calendar,

    widget = wibox.container.place
}
-- Update calendar date
local month_offset = 0
local function generate_date()
    if (month_offset == 0)
    then
        return os.date('*t')
    else
        local date = os.date('*t')
        return { year = date.year, month = date.month + month_offset }
    end
end
local function update_calendar()
    calendar.date = generate_date()
end
-- Generate calendar button binds
local calendar_buttons = {
    -- Go to current month on MMB
    awful.button(
        { }, 2,
        function ()
            month_offset = 0;
            update_calendar()
        end
    ),
    -- Go to next month on SCROLL UP
    awful.button(
        { }, 4,
        function ()
            month_offset = month_offset + 1;
            update_calendar()
        end
    ),
    -- Go to previous month on SCROLL DOWN
    awful.button(
        { }, 5,
        function ()
            month_offset = month_offset - 1;
            update_calendar()
        end
    ),
}
final_widget.buttons = calendar_buttons


return final_widget
