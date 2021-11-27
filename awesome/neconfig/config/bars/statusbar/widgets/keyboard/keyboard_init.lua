-- Load libraries
local awful = require('awful')
local wibox = require('wibox')


-- Generate keyboard layout widget
return wibox.widget {
    widget = wibox.container.place,

    awful.widget.keyboardlayout()
}
