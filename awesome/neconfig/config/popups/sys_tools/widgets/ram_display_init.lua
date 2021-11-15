local vicious = require('vicious')
local wibox = require('wibox')

local ram_display = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(ram_display, vicious.widgets.mem, '$2MiB/$3MiB', 1)

return ram_display
