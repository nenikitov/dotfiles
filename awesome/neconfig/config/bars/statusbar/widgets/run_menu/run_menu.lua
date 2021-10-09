-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')

-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')
require('neconfig.config.utils.widget_utils')


local function get_run_menu(bar_info)
    -- Get style from the theme
    local font_size = beautiful.get_font_height(beautiful.font) * 0.75
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

    local run_menu_launcher = wibox.widget {
        text = '\u{f00a}',
        align = 'center',
        valign = 'center',
        forced_width = width,
        forced_height = height,
        buttons = {
            awful.button (
                { }, 1,
                function ()
                    awful.util.spawn(user_vars_conf.apps.default_apps.run_menu)
                end
            )
        },

        widget = wibox.widget.textbox
    }

    return run_menu_launcher
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_run_menu(...) end }
)
