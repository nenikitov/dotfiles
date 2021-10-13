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

    -- Apply text properties if contents is textbox
    if (contents.get_text and contents.set_markup)
    then
        contents:set_markup('<span font_weight="' .. props.font_weight .. '">' .. contents:get_text() .. '</span>')
        contents.font = font .. ' ' .. (font_size * props.font_size)
    end
    
    return wibox.widget {
        {
            contents,

            widget = wibox.container.place
        },

        bg = props.background_color,
        widget = wibox.container.background
    }
end

return wibox.widget {
    {
        date = os.date('*t'),
        font = font .. ' ' .. font_size,
        spacing = beautiful.get_font_height(font) / 2,
        week_numbers = false,
        start_sunday = false,
        long_weekdays = true,
        fn_embed = calendar_style,
        widget = wibox.widget.calendar.month
    },

    widget = wibox.container.place
}
