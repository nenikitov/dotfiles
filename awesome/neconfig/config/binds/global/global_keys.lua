-- Load libraries
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local menubar = require('menubar')
-- Load custom modules
local tag_binds = require('neconfig.config.binds.global.global_tag_binds')
local menu_user_conf = require('neconfig.config.user.menu_user_conf')
local binds_user_conf = require('neconfig.config.user.binds_user_conf')
local apps_user_conf = require('neconfig.config.user.apps_user_conf')
local app_utils = require('neconfig.config.utils.app_utils')

-- Get variables
local super_key = binds_user_conf.keys.super_key
local ctrl_key = binds_user_conf.keys.ctrl_key
local shift_key = binds_user_conf.keys.shift_key
local alt_key = binds_user_conf.keys.alt_key
local terminal = apps_user_conf.default_apps.terminal



-- █▀▀ █   █▀█ █▄▄ ▄▀█ █     █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
-- TODO create better key binds
local global_keys = {
    --#region Awesome WM controls
    -- Show all bind on SUPER + S
    awful.key(
        { super_key }, 's',
        hotkeys_popup.show_help,
        { description = 'show help', group = 'awesome' }
    ),
    --- Menu on SUPER + W
    awful.key(
        { super_key }, 'w',
        function ()
            menu_user_conf:show()
        end,
        { description = 'show main menu', group = 'awesome' }
    ),
    -- Reload Awesome on SUPER + CTRL + R
    awful.key(
        { super_key, ctrl_key }, 'r',
        awesome.restart,
        { description = 'reload awesome', group = 'awesome' }
    ),
    -- Quit Awesome on SUPER + SHIFT + Q
    awful.key(
        { super_key, shift_key }, 'q',
        awesome.quit,
        { description = 'quit awesome', group = 'awesome' }
    ),
    --#endregion

    --#region Tag interaction
    -- Go to next tag on SUPER + RIGHT ARROW
    awful.key(
        { super_key }, 'Right',
        awful.tag.viewnext,
        { description = 'view next', group = 'tag' }
    ),
    -- Go to previous tag on SUPER + LEFT ARROW
    awful.key(
        { super_key }, 'Left',
        awful.tag.viewprev,
        { description = 'view previous', group = 'tag' }
    ),
    -- Go back in tag interaction history on SUPER + ESC
    awful.key(
        { super_key }, 'Escape',
        awful.tag.history.restore,
        { description = 'go back', group = 'tag' }
    ),
    --#endregion

    --#region Client focus manipulation
    -- Focus next client on SUPER + J
    awful.key(
        { super_key }, 'j',
        function ()
            awful.client.focus.byidx(1)
        end,
        { description = 'focus next by index', group = 'client' }
    ),
    -- Focus previous client on SUPER + K
    awful.key(
        { super_key }, 'k',
        function ()
            awful.client.focus.byidx(-1)
        end,
        { description = 'focus previous by index', group = 'client' }
    ),
    --#endregion

    --#region Client manipulation
    -- Swap the current client with the next one in the wibar on SUPER + SHIFT + J
    awful.key(
        { super_key, shift_key }, 'j',
        function ()
            awful.client.swap.byidx(1)
        end,
        { description = 'swap with next client by index', group = 'client' }
    ),
    -- Swap the current client with the previous one in the wibar on SUPER + SHIFT + K
    awful.key(
        { super_key, shift_key }, 'k',
        function ()
            awful.client.swap.byidx(-1)
        end,
        { description = 'swap with previous client by index', group = 'client' }
    ),
    -- Focus urgent client on SUPER + U
    awful.key(
        { super_key }, 'u',
        awful.client.urgent.jumpto,
        { description = 'jump to urgent client', group = 'client' }
    ),
    -- Focus previously used client on SUPER + TAB
    awful.key(
        { super_key }, 'Tab',
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = 'go back', group = 'client' }
    ),
    -- Restore minimized on SUPER + CTRL + N
    awful.key(
        { super_key, ctrl_key }, 'n',
        function ()
            local c = awful.client.restore()
            if c then
                c:emit_signal(
                    'request::activate',
                    'key.unminimize',
                    {raise = true}
                )
            end
        end,
        { description = 'restore minimized', group = 'client' }
    ),
    --#endregion

    --#region Screen
    -- Focus next screen on SUPER + CTRL + J
    awful.key(
        { super_key, ctrl_key }, 'j',
        function ()
            awful.screen.focus_relative(1)
        end,
        { description = 'focus the next screen', group = 'screen' }
    ),
    -- Focus previous screen on SUPER + CTRL + K
    awful.key(
        { super_key, ctrl_key }, 'k',
        function ()
            awful.screen.focus_relative(-1)
        end,
        { description = 'focus the previous screen', group = 'screen' }
    ),
    --#endregion

    --#region Launcher
    -- Terminal on SUPER + ENTER
    awful.key(
        { super_key }, 'Return',
        function ()
            awful.spawn(terminal)
        end,
        { description = 'open a terminal', group = 'launcher' }
    ),
    -- Run launcher on SUPER + R
    awful.key(
        { super_key }, 'r',
        function ()
            awful.util.spawn(apps_user_conf.default_apps.run_menu)
        end,
        { description = 'open run launcher', group = 'launcher' }
    ),
    -- ? Do I need this?
    --[[
    -- LUA code on SUPER + X
    awful.key(
        { super_key }, 'x',
        function ()
            awful.prompt.run {
                prompt = 'Run Lua code: ',
                textbox = awful.screen.focused().statusbar.widgets.promptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. '/history_eval'
            }
        end,
        { description = 'lua execute prompt', group = 'awesome' }
    ),
    ]]
    -- Menubar on SUPER + P
    awful.key(
        { super_key }, 'p',
        function()
            menubar.show()
        end,
        { description = 'show the menubar', group = 'launcher' }
    ),
    --#endregion

    --#region Tiled grid manipulation manipulation
    -- Increase master width on SUPER + L
    awful.key(
        { super_key }, 'l',
        function ()
            awful.tag.incmwfact(0.05)
        end,
        { description = 'increase master width factor', group = 'layout' }
    ),
    -- Decrease master width on SUPER + H
    awful.key(
        { super_key }, 'h',
        function ()
            awful.tag.incmwfact(-0.05)
        end,
        { description = 'decrease master width factor', group = 'layout' }
    ),
    -- Increase the number of master clients on SUPER + SHIFT + H
    awful.key(
        { super_key, shift_key }, 'h',
        function ()
            awful.tag.incnmaster( 1, nil, true)
        end,
        { description = 'increase the number of master clients', group = 'layout' }
    ),
    -- Decrease the number of master clients on SUPER + SHIFT + L
    awful.key(
        { super_key, shift_key }, 'l',
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = 'decrease the number of master clients', group = 'layout' }
    ),
    -- Increase number of columns on SUPER + CTRL + H
    awful.key(
        { super_key, ctrl_key }, 'h',
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        { description = 'increase the number of columns', group = 'layout' }
    ),
    -- Decrease number of columns on SUPER + CTRL + L
    awful.key(
        { super_key, ctrl_key }, 'l',
        function ()
            awful.tag.incncol(-1, nil, true)
        end,
        { description = 'decrease the number of columns', group = 'layout' }
    ),

    -- Layout manipulation
    -- Select next layout type on SUPER + SPACE
    awful.key(
        { super_key }, 'space',
        function ()
            awful.layout.inc(1)
        end,
        { description = 'select next', group = 'layout' }
    ),
    -- Select previous layout type on SUPER + SHIFT + SPACE
    awful.key(
        { super_key, shift_key }, 'space',
        function ()
            awful.layout.inc(-1)
        end,
        { description = 'select previous', group = 'layout' }
    ),
    --#endregion

    -- TODO make these key binds more "official"
    awful.key(
        { super_key }, 'i',
        function ()
            local focused_screen = awful.screen.focused()
            focused_screen.statusbar:toggle()
        end,
        { description = 'toggle statusbar on current screen', group = 'test' }
    ),
    awful.key(
        { super_key, shift_key }, 'i',
        function ()
            local focused_screen = awful.screen.focused()
            local new_visibility = not focused_screen.statusbar:get_visible()

            for s in screen do
                s.statusbar:set_visible(new_visibility)
            end
        end
    ),
    awful.key(
        { }, 'XF86MonBrightnessDown',
        function ()
            app_utils.increase_brightness(-5)
        end,
        { description = 'Decrease brightness by 5%', group = 'screen'}
    ),
    awful.key(
        { }, 'XF86MonBrightnessUp',
        function ()
            app_utils.increase_brightness(5)
        end,
        { description = 'Increase brightness by 5%', group = 'screen'}
    ),
    -- Tag binds
    table.unpack(tag_binds)
}

return global_keys