-- Load libraries
local wibox = require('wibox')
local user_vars = require('config.user.user_vars')

-- Get variables
local datetime_format = user_vars.statusbar.datetime_format

return wibox.widget.textclock(datetime_format)
