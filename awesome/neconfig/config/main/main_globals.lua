-- Load custom modules
local user_titlebar= require('neconfig.user.config.widgets.user_titlebar')


GLOBALS = {
    decoration_visibility = {
        titlebars = user_titlebar.visible,
        statusbars = true
    }
}
