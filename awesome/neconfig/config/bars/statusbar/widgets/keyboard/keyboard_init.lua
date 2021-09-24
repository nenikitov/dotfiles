-- Load libraries
local awful = require('awful')
local wibox = require('wibox')


-- Generate keyboard layout widget
return wibox.widget {
    layout = wibox.layout.stack,

    {
        widget = wibox.container.place,
        
        awful.widget.keyboardlayout()
    }
}
