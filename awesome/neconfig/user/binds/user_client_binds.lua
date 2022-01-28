-- Load libraries
local awful = require('awful')
-- Load custom modules
local binds_user_conf = require('neconfig.config.user.binds_user_conf')

-- Get variables
local super_key = binds_user_conf.keys.super_key



-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▀▄▀█ █▀█ █ █ █▀ █▀▀   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ ▀ █ █▄█ █▄█ ▄█ ██▄   █▄█ █ █ ▀█ █▄▀ ▄█
local client_buttons = {
    -- Activate on LMB
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
    -- Move on SUPER + LMB
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
    -- Resize on SUPER + RMB
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


-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local client_keys = {
    --#region Display mode

    -- Toggle full-screen on SUPER + F
    awful.key(
        { super_key }, 'f',
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = 'toggle full-screen', group = 'client - display' }
    ),
    -- Maximize client on SUPER + M
    awful.key(
        { super_key }, 'm',
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = '(un)maximize', group = 'client - display' }
    ),
    -- Minimize client on SUPER + N
    awful.key(
        { super_key }, 'n',
        function(c)
            c.minimized = true
        end,
        { description = 'minimize', group = 'client - display' }
    ),
    -- Toggle floating on SUPER + CTRL + SPACE
    awful.key(
        { super_key, 'Control' }, 'space',
        awful.client.floating.toggle,
        { description = 'toggle floating', group = 'client - display' }
    ),
    -- Toggle keep on top on SUPER + T
    awful.key(
        { super_key }, 't',
        function(c)
            c.ontop = not c.ontop
        end,
        { description = 'toggle keep on top', group = 'client - display' }
    ),
    --#endregion

    --#region Position

    -- Move client to master on SUPER + CTRL + ENTER
    awful.key(
        { super_key, 'Control' }, 'Return',
        function(c)
            c:swap(awful.client.getmaster())
        end,
        { description = 'move to master', group = 'client - position' }
    ),
    -- Move client to another screen on SUPER + O
    awful.key(
        { super_key }, 'o',
        function(c)
            c:move_to_screen()
        end,
        { description = 'move to screen', group = 'client - position' }
    ),
    --#endregion

    --#region Manipulation
    -- Close on SUPER + SHIFT + C
    awful.key(
        { super_key, 'Shift' }, 'c',
        function(c)
            c:kill()
        end,
        { description = 'close', group = 'client - interaction' }
    ),
    --#endregion
}

return {
    keys = client_keys,
    buttons = client_buttons
}
