-- Load libraries
local awful = require('awful')
-- Load custom modules
local menu_user_conf = require('neconfig.config.user.menu_user_conf')



-- █▀▀ █   █▀█ █▄▄ ▄▀█ █     █▀▄▀█ █▀█ █ █ █▀ █▀▀   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   █ ▀ █ █▄█ █▄█ ▄█ ██▄   █▄█ █ █ ▀█ █▄▀ ▄█
local global_buttons = {
    -- Toggle menu on RMB
    awful.button(
        { }, 3,
        function()
            menu_user_conf:toggle()
        end
    ),
    -- Go to next tag on SCROLL UP
    awful.button(
        { }, 4,
        awful.tag.viewnext
    ),
    -- Go to previous tag on SCROLL DOWN
    awful.button(
        { }, 5,
        awful.tag.viewprev
    )
}

return global_buttons
