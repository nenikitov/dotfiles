-- Load libraries
local awful = require('awful')
-- Load custom modules
local binds_user_conf = require('neconfig.config.user.binds_user_conf')

-- Get variables
local super_key = binds_user_conf.keys.super_key



-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local client_buttons = {
    -- Activate client on LMB
    awful.button(
        { }, 1,
        function(c)
            c:emit_signal(
                'request::activate',
                'mouse_click',
                { raise = true }
            )
        end
    ),
    -- Move client on SUPER + LMB
    awful.button(
        { super_key }, 1,
        function(c)
            c:emit_signal(
                'request::activate',
                'mouse_click',
                { raise = true }
            )
            awful.mouse.client.move(c)
        end
    ),
    -- Resize client on SUPER + RMB
    awful.button(
        { super_key }, 3,
        function(c)
            c:emit_signal(
                'request::activate',
                'mouse_click',
                { raise = true }
            )
            awful.mouse.client.resize(c)
        end
    )
}

return client_buttons