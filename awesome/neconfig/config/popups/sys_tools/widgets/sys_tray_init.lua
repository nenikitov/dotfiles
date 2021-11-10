-- Load libraries
local wibox = require('wibox')

local systray = wibox.widget.systray()
systray.forced_width = 100
systray.forced_height = 24
systray.visible = true

return systray