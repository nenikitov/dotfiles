-- Load libraries
local awful = require('awful')
local wibox = require('wibox')

-- Load custom modules
local apps_user_conf = require('neconfig.config.user.apps_user_conf')

-- Construct widget
return wibox.widget {
    text = '\u{f078}',
    align = 'center',
    valign = 'center',
    buttons = {
        awful.button (
            { }, 1,
            function ()
                awful.util.spawn(apps_user_conf.default_apps.run_menu)
            end
        )
    },

    widget = wibox.widget.textbox
}
