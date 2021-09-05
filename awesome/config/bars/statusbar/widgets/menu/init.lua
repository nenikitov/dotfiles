-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')

-- Get variables
local user_menu = require('config.user.user_menu')


-- Construct launcher widget
return awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = user_menu
})