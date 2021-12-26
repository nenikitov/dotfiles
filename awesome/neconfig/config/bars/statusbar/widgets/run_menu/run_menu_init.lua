-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
local apps_user_conf = require('neconfig.config.user.apps_user_conf')

-- Get variables
local font_height = beautiful.get_font_height(beautiful.font)


-- Construct run menu widget
return wibox.widget {
    widget = wibox.widget.textbox,

    text = '\u{f078}',
    align = 'center',
    valign = 'center',
    forced_width = font_height * 0.75,
    forced_height = font_height * 0.75,

    buttons = {
        awful.button (
            { }, 1,
            function ()
                awful.util.spawn(apps_user_conf.default_apps.run_menu)
            end
        )
    }
}
