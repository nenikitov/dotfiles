-- Load libraries
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Generate 2 separate widgets for date and time
local time = wibox.widget {
    wibox.widget.textclock(user_vars_conf.statusbar.clock.time_format),
    widget = wibox.container.place
}
local date = wibox.widget {
    wibox.widget.textclock(user_vars_conf.statusbar.clock.date_format),
    widget = wibox.container.place
}
-- Set textclock font sizes
local time_children = time:get_all_children()
for _, child in pairs(time_children)
do
    child.font = beautiful.user_vars_theme.general.font .. ' '
        .. (beautiful.user_vars_theme.general.text_size * 0.8)
end
local date_children = date:get_all_children()
for _, child in pairs(date_children)
do
    child.font = beautiful.user_vars_theme.general.font .. ' '
        .. (beautiful.user_vars_theme.general.text_size * 0.75)
end

-- Construct layered widget
return wibox.widget {
    time,
    date,
    layout = wibox.layout.flex.vertical,
    fill_space = true
}
