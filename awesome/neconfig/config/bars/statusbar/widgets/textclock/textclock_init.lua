-- Load libraries
local wibox = require('wibox')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

return wibox.widget.textclock(user_vars_conf.statusbar.datetime_format)
