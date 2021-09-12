-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')

-- Load custom modules
local user_menu = require('neconfig.config.user.user_menu')
require('neconfig.config.utils.widget_utils')


-- Construct menu widget
local function get_menu(size)
    local launcher = awful.widget.launcher {
        image = beautiful.system_icon,
        menu = user_menu,
    }

    return square_widget(launcher, size, 5)
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_menu(...) end }
)

