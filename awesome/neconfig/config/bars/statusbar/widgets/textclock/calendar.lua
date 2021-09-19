-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')


return wibox.widget {
    date = os.date('*t'),
    font = beautiful.font,
    spacing = 10,
    week_numbers = false,
    start_sunday = false,
    long_weekdays = true,
    widget = wibox.widget.calendar.month
}
