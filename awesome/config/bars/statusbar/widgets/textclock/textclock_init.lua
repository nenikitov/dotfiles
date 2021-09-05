-- Load libraries
local wibox = require('wibox')
-- Load custom modules
local user_vars = require('config.user.user_vars')

return wibox.widget.textclock(user_vars.statusbar.datetime_format)
