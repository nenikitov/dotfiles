-- Load libraries
local gears = require('gears')
local awful = require('awful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Get variables
local super_key = user_vars_conf.binds.keys.super_key


-- Customize this
-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local function get_client_buttons()
    local client_buttons = gears.table.join(
        -- Activate client on LMB
        awful.button(
            { }, 1,
            function (c)
                c:emit_signal('request::activate', 'mouse_click', { raise = true })
            end
        ),
        -- Move client on SUPER + LMB
        awful.button(
            { super_key }, 1,
            function (c)
                c:emit_signal('request::activate', 'mouse_click', { raise = true })
                awful.mouse.client.move(c)
            end
        ),
        -- Resize client on SUPER + RMB
        awful.button(
            { super_key }, 3,
            function (c)
                c:emit_signal('request::activate', 'mouse_click', { raise = true })
                awful.mouse.client.resize(c)
            end
        )
    )

    return client_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_client_buttons() end }
)
