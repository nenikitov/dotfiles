-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')

-- Load custom modules
local user_menu = require('neconfig.config.user.user_menu')


-- Construct menu widget
return awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = user_menu,
})