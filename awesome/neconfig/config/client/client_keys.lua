-- Load libraries
local gears = require('gears')
local awful = require('awful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Get variables
local super_key = user_vars_conf.binds.keys.super_key


-- Customize this
-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▀▄▀█ █▀█ █ █ █▀ █▀▀   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ ▀ █ █▄█ █▄█ ▄█ ██▄   █▄█ █ █ ▀█ █▄▀ ▄█
local function get_client_keys()
    local client_keys = gears.table.join(
        -- Toggle fullscreen on SUPER + F
        awful.key(
            { super_key }, 'f',
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = 'toggle fullscreen', group = 'client' }
        ),
        -- Close client on SUPER + SHIFT + C
        awful.key(
            { super_key, 'Shift' }, 'c',
            function (c)
                c:kill()
            end,
            { description = 'close', group = 'client' }
        ),
        -- Toggle floating client on SUPER + CTRL + SPACE
        awful.key(
            { super_key, 'Control' }, 'space',
            awful.client.floating.toggle,
            { description = 'toggle floating', group = 'client' }
        ),
        -- Move client to master on SUPER + CTRL + ENTER
        awful.key(
            { super_key, 'Control' }, 'Return',
            function (c)
                c:swap(awful.client.getmaster())
            end,
            { description = 'move to master', group = 'client' }
        ),
        -- Move client to another screen on SUPER + O
        awful.key(
            { super_key }, 'o',
            function (c)
                c:move_to_screen()
            end,
            { description = 'move to screen', group = 'client' }
        ),
        -- Pin client to top on SUPER + T
        awful.key(
            { super_key }, 't',
            function (c)
                c.ontop = not c.ontop
            end,
            { description = 'toggle keep on top', group = 'client' }
        ),
        -- Minimize client on SUPER + N
        awful.key(
            { super_key }, 'n',
            function (c)
                c.minimized = true
            end,
            { description = 'minimize', group = 'client' }
        ),
        -- Maximize client on SUPER + M
        awful.key(
            { super_key }, 'm',
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = '(un)maximize', group = 'client' }
        ),
        -- Maximize client vertically on SUPER + CTRL + M
        awful.key(
            { super_key, 'Control' }, 'm',
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = '(un)maximize vertically', group = 'client' }
        ),
        -- Maximize client horizontally on SUPER + SHIFT + M
        awful.key(
            { super_key, 'Shift' }, 'm',
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            { description = '(un)maximize horizontally', group = 'client' }
        )
    )

    return client_keys
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_client_keys() end }
)

