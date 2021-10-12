-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')


-- Get style variables
local font = beautiful.font
local calendar_style_lookup = {
    -- Whole month container
    month = {
        bg = '#0000'
    },
    -- Normal days
    normal = {
        bg = '#0000'
    },
    -- Current day
    focus = {
        bg = '#fff4'
    },
    -- Header (month name)
    header = {
        bg = '#0000'
    },
    -- Header (name of the days)
    weekday = {
        bg = '#0000'
    }
}
local function calendar_style(contents, flag, date)
    local props = calendar_style_lookup[flag]
    return wibox.widget {
        contents,

        bg = props.bg,
        widget = wibox.container.background
    }
end

return wibox.widget {
    {
        date = os.date('*t'),
        font = font,
        spacing = 10,
        week_numbers = false,
        start_sunday = false,
        long_weekdays = false,
        fn_embed = calendar_style,
        widget = wibox.widget.calendar.month
    },

    widget = wibox.container.place
}
