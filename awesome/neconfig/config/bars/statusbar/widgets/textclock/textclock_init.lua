-- Load libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Generate 2 separate widgets for date and time
local top_time = wibox.widget {
    wibox.widget.textclock(user_vars_conf.statusbar.widgets.clock.top_format),
    widget = wibox.container.place
}
local bottom_time = wibox.widget {
    wibox.widget.textclock(user_vars_conf.statusbar.widgets.clock.bottom_format),
    widget = wibox.container.place
}
-- Set font size for the date on the bottom
for _, child in pairs(bottom_time:get_all_children())
do
    child.font = beautiful.user_vars_theme.general.font .. ' '
        .. (beautiful.user_vars_theme.general.text_size * 0.75)
end

-- Construct layered widget
return wibox.widget {
    top_time,
    bottom_time,
    layout = wibox.layout.flex.vertical,
    fill_space = true
}
