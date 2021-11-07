-- Load libraries
local awful = require('awful')
local wibox = require('wibox')

-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Construct widget
return wibox.widget {
    text = '\u{f078}',
    align = 'center',
    valign = 'center',
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
