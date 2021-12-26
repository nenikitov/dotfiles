-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')

-- Load custom modules
local menu_user_conf = require('neconfig.config.user.menu_user_conf')


local font_height = beautiful.get_font_height(beautiful.font)
-- Construct menu widget
local launcher = awful.widget.launcher {
    image = beautiful.system_icon,
    menu = menu_user_conf
}

launcher.forced_width = font_height * 0.75
launcher.forced_height = font_height * 0.75
launcher.halign = 'center'
launcher.valign = 'center'

return launcher
