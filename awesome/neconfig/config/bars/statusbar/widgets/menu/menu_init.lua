-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')

-- Load custom modules
local menu_user_conf = require('neconfig.config.user.menu_user_conf')
local widget_utils = require('neconfig.config.utils.widget_utils')


local function get_menu(bar_info)
    -- Construct menu widget
    local launcher = awful.widget.launcher {
        image = beautiful.system_icon,
        menu = menu_user_conf,
    }

    launcher.forced_width = bar_info.contents_size * 0.75
    launcher.forced_height = bar_info.contents_size * 0.75
    launcher.halign = 'center'
    launcher.valign = 'center'

    return launcher
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_menu(...) end }
)
