-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

-- Load custom modules
local user_menu = require('neconfig.config.user.user_menu')
require('neconfig.config.utils.widget_utils')


local function get_menu(bar_info)
    -- Get style from the theme
    local font_size = beautiful.get_font_height(beautiful.font)
    local width
    local height
    if (bar_info.position == 'top' or bar_info.position == 'bottom')
    then
        width = font_size
        height = bar_info.contents_size
    else
        height = font_size
        width = bar_info.contents_size
    end

    -- Construct menu widget
    local launcher = awful.widget.launcher {
        image = beautiful.system_icon,
        menu = user_menu,
    }

    launcher.forced_width = width
    launcher.forced_height = height
    launcher.halign = 'center'
    launcher.valign = 'center'

    return launcher
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_menu(...) end }
)
