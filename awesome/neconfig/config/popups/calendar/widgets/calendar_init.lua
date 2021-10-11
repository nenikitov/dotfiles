-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')


-- Get style variables
local font = beautiful.font
local calendar_style_lookup = {
    -- Whole month container
    month = {

    },
    -- Normal days
    normal = {

    },
    -- Current day
    focus = {

    },
    -- Header (month name)
    header = {

    },
    -- Header (name of the days)
    weekday = {

    }
}
local function calendar_style(widget, flag, date)
    return widget
end

return wibox.widget {
    date = os.date('*t'),
    font = font,
    spacing = 10,
    week_numbers = false,
    start_sunday = false,
    long_weekdays = false,
    fn_embed = calendar_style,
    widget = wibox.widget.calendar.month
}
