-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_interactions = require('neconfig.user.config.binds.user_interactions')

-- Get variables
local super_key = user_interactions.keys.super_key
local more_key = user_interactions.keys.more_key
local less_key = user_interactions.keys.less_key
local resize_val = user_interactions.keyboard_client_movement.resize
local move_val = user_interactions.keyboard_client_movement.move


-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▀▄▀█ █▀█ █ █ █▀ █▀▀   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ ▀ █ █▄█ █▄█ ▄█ ██▄   █▄█ █ █ ▀█ █▄▀ ▄█
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
    -- Move on "SUPER" + LMB
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
    -- Resize on "SUPER" + RMB
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


-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local client_keys = {
    --#region Display mode

    -- Toggle full screen on "SUPER" + F
    awful.key(
        { super_key }, 'f',
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = 'toggle full screen', group = 'client - display' }
    ),
    -- Maximize client on "SUPER" + M
    awful.key(
        { super_key }, 'm',
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = '(un)maximize', group = 'client - display' }
    ),
    -- Minimize client on "SUPER" + N
    awful.key(
        { super_key }, 'n',
        function(c)
            c.minimized = true
        end,
        { description = 'minimize', group = 'client - display' }
    ),
    -- Toggle floating on "SUPER" + "MORE" + SPACE
    awful.key(
        { super_key, more_key }, 'space',
        awful.client.floating.toggle,
        { description = 'toggle floating', group = 'client - display' }
    ),
    -- Toggle keep on top on "SUPER" + T
    awful.key(
        { super_key }, 't',
        function(c)
            c.ontop = not c.ontop
        end,
        { description = 'toggle keep on top', group = 'client - display' }
    ),
    --#endregion

    --#region Screen

    -- Move client to next screen on "SUPER" + "LESS" + P
    awful.key(
        { super_key, less_key }, 'p',
        function(c)
            c:move_to_screen()
        end,
        { description = 'move to next screen', group = 'client - screen' }
    ),
    -- Move client to previous screen on "SUPER" + "LESS" + O
    awful.key(
        { super_key, less_key }, 'o',
        function(c)
            c:move_to_screen(c.screen.index - 1)
        end,
        { description = 'move to previous screen', group = 'client - screen' }
    ),
    --#endregion

    --#region Position

    -- Move client up on "SUPER" + UP
    awful.key(
        { super_key }, 'Up',
        function(c)
            c:relative_move(0, -move_val, 0, 0)
        end,
        { description = 'move client up', group = 'client - position' }
    ),
    -- Move client down on "SUPER" + DOWN
    awful.key(
        { super_key }, 'Down',
        function(c)
            c:relative_move(0, move_val, 0, 0)
        end,
        { description = 'move client down', group = 'client - position' }
    ),
    -- Move client right on "SUPER" + RIGHT
    awful.key(
        { super_key }, 'Right',
        function(c)
            c:relative_move(move_val, 0, 0, 0)
        end,
        { description = 'move client right', group = 'client - position' }
    ),
    -- Move client left on "SUPER" + LEFT
    awful.key(
        { super_key }, 'Left',
        function(c)
            c:relative_move(-move_val, 0, 0, 0)
        end,
        { description = 'move client left', group = 'client - position' }
    ),
    -- Expand client up on "SUPER" + "MORE" + UP
    awful.key(
        { super_key, more_key }, 'Up',
        function(c)
            c:relative_move(0, -resize_val, 0, resize_val)
        end,
        { description = 'expand client up', group = 'client - position' }
    ),
    -- Expand client down on "SUPER" + "MORE" + DOWN
    awful.key(
        { super_key, more_key }, 'Down',
        function(c)
            c:relative_move(0, 0, 0, resize_val)
        end,
        { description = 'expand client down', group = 'client - position' }
    ),
    -- Expand client right on "SUPER" + "MORE" + RIGHT
    awful.key(
        { super_key, more_key }, 'Right',
        function(c)
            c:relative_move(0, 0, resize_val, 0)
        end,
        { description = 'expand client right', group = 'client - position' }
    ),
    -- Expand client left on "SUPER" + "MORE" + LEFT
    awful.key(
        { super_key, more_key }, 'Left',
        function(c)
            c:relative_move(-resize_val, 0, resize_val, 0)
        end,
        { description = 'expand client left', group = 'client - position' }
    ),
    -- Shrink client up on "SUPER" + "LESS" + UP
    awful.key(
        { super_key, less_key }, 'Up',
        function(c)
            if c.height > resize_val then
                c:relative_move(0, 0, 0, -resize_val)
            end
        end,
        { description = 'shrink client up', group = 'client - position' }
    ),
    -- Shrink client down on "SUPER" + "LESS" + DOWN
    awful.key(
        { super_key, less_key }, 'Down',
        function(c)
            if c.height > resize_val then
                c:relative_move(0, resize_val, 0, -resize_val)
            end
        end,
        { description = 'shrink client down', group = 'client - position' }
    ),
    -- Shrink client right on "SUPER" + "LESS" + RIGHT
    awful.key(
        { super_key, less_key }, 'Right',
        function(c)
            if c.width > resize_val then
                c:relative_move(resize_val, 0, -resize_val, 0)
            end
        end,
        { description = 'shrink client right', group = 'client - position' }
    ),
    -- Shrink client left on "SUPER" + "LESS" + LEFT
    awful.key(
        { super_key, less_key }, 'Left',
        function(c)
            if c.width > resize_val then
                c:relative_move(0, 0, -resize_val, 0)
            end
        end,
        { description = 'shrink client left', group = 'client - position' }
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
