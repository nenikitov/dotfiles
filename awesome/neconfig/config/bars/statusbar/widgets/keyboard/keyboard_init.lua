-- Load libraries
local awful = require('awful')
local wibox = require('wibox')


-- Generate keyboard layout widget
return wibox.widget {
    awful.widget.keyboardlayout(),


    widget = wibox.container.place
}
