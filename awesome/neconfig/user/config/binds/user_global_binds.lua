-- Load libraries
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
-- Load custom modules
local user_interactions = require('neconfig.user.config.binds.user_interactions')
local user_apps = require('neconfig.user.config.user_apps')
local utils_apps = require('neconfig.config.utils.utils_apps')
local user_menu = require('neconfig.user.config.widgets.user_menu')
local user_desktop = require('neconfig.user.config.user_desktop')

-- Get variables
local tag_num = #(user_desktop.tag_names)
local terminal = user_apps.default_apps.terminal
local super_key = user_interactions.keys.super_key
local more_key = user_interactions.keys.more_key
local less_key = user_interactions.keys.less_key
local resize_master_val = user_interactions.keyboard_client_movement.master



-- █▀▀ █   █▀█ █▄▄ ▄▀█ █     █▀▄▀█ █▀█ █ █ █▀ █▀▀   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   █ ▀ █ █▄█ █▄█ ▄█ ██▄   █▄█ █ █ ▀█ █▄▀ ▄█
local global_buttons = {
    -- Toggle menu on RMB
    awful.button(
        { }, 3,
        function()
            user_menu:toggle()
        end
    )
}


-- █▀▀ █▀█ █▄▄ ▄▀█ █     ▀█▀ ▄▀█ █▀▀   █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄█ █▄█ █▀█ █▄▄    █  █▀█ █▄█   █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local function tag_key_bind(i)
    local current_tag_keys = {
        --#region Display

        -- View tag on "SUPER" + "NUMBER"
        awful.key(
            { super_key }, '#' .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = 'view tag #' .. i, group = 'tag - display' }
        ),
        -- Toggle tag on "SUPER" + "MORE" + NUMBER
        awful.key(
            { super_key, more_key }, '#' .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = 'toggle tag #' .. i, group = 'tag - display' }
        ),
        --#endregion

        --#region Clients

        -- Move client to tag on "SUPER" + "LESS" + "NUMBER"
        awful.key(
            { super_key, less_key }, '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = 'move client to tag #'..i, group = 'tag - clients' }
        ),
        -- Toggle tag on client on "SUPER" + "MORE" + "LESS" + "NUMBER"
        awful.key(
            { super_key, more_key, less_key }, '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = 'toggle client on tag #' .. i, group = 'tag - clients' }
        ),
        --#endregion
    }

    return current_tag_keys
end
local all_tag_keys = {}
for i = 1, tag_num do
    local tag_keys = tag_key_bind(i)

    for _, tag_key in ipairs(tag_keys) do
        table.insert(all_tag_keys, tag_key)
    end
end


-- █▀▀ █   █▀█ █▄▄ ▄▀█ █     █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local global_keys = {
    --#region Awesome WM

    -- Show all binds on "SUPER" + S
    awful.key(
        { super_key }, 's',
        hotkeys_popup.show_help,
        { description = 'show help', group = 'awesome' }
    ),
    -- Restart Awesome WM on "SUPER" + "MORE" + "LESS" + R
    awful.key(
        { super_key, more_key, less_key }, 'r',
        awesome.restart,
        { description = 'restart awesome', group = 'awesome' }
    ),
    -- Quit Awesome on "SUPER" + "MORE" + "LESS" + Q
    awful.key(
        { super_key, more_key, less_key }, 'q',
        awesome.quit,
        { description = 'quit awesome', group = 'awesome' }
    ),
    --#endregion

    --#region Client display

    -- Restore minimized on "SUPER" + "MORE" + N
    awful.key(
        { super_key, more_key }, 'n',
        function()
            local c = awful.client.restore()
            if c then
                c:emit_signal(
                    'request::activate',
                    'key.unminimize',
                    {raise = true}
                )
            end
        end,
        { description = 'restore minimized', group = 'client - display' }
    ),
    -- Toggle titlebars on "SUPER" + "MORE" + I
    awful.key(
        { super_key, more_key }, 'i',
        function()
            GLOBALS.decoration_visibility.titlebars = not GLOBALS.decoration_visibility.titlebars

            for _, c in ipairs(client.get()) do
                c:emit_signal('titlebar::update_visibility')
            end
        end,
        { description = 'toggle titlebars', group = 'client - display' }
    ),
    -- Screenshot on "SUPER" + "MORE" + S
    awful.key(
        { super_key, more_key }, 's',
        function()
            utils_apps.take_screenshot()
        end,
        { description = 'screenshot', group = 'utilities' }
    ),
    --#endregion


    --#region Client focus

    -- Focus urgent client on "SUPER" + U
    awful.key(
        { super_key }, 'u',
        awful.client.urgent.jumpto,
        { description = 'jump to urgent client', group = 'client - focus' }
    ),

    -- Focus the next client up on "SUPER" + K
    awful.key(
        { super_key }, 'k',
        function()
            awful.client.focus.global_bydirection('up')
        end,
        { description = 'focus next client up', group = 'client - focus' }
    ),
    -- Focus the next client down on "SUPER" + J
    awful.key(
        { super_key }, 'j',
        function()
            awful.client.focus.global_bydirection('down')
        end,
        { description = 'focus next client down', group = 'client - focus' }
    ),
    -- Focus the next client right on "SUPER" + L
    awful.key(
        { super_key }, 'l',
        function()
            awful.client.focus.global_bydirection('right')
        end,
        { description = 'focus next client right', group = 'client - focus' }
    ),
    -- Focus the next client left on "SUPER" + H
    awful.key(
        { super_key }, 'h',
        function()
            awful.client.focus.global_bydirection('left')
        end,
        { description = 'focus next client left', group = 'client - focus' }
    ),
    -- Focus next client by id on "SUPER" + TAB
    awful.key(
        { super_key }, 'Tab',
        function()
            awful.client.focus.byidx(1)
        end,
        { description = 'focus next client by id', group = 'client - focus' }
    ),
    -- Focus previous client by id on "SUPER" + "MORE" + TAB
    awful.key(
        { super_key, more_key }, 'Tab',
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = 'focus previous client by id', group = 'client - focus' }
    ),
    --#endregion

    --#region Client swap

    -- Swap with the next client up on "SUPER" + "LESS" + K
    awful.key(
        { super_key, less_key }, 'k',
        function()
            awful.client.swap.global_bydirection('up')
        end,
        { description = 'swap with next client up', group = 'client - swap' }
    ),
    -- Swap with the next client down on "SUPER" + "LESS" + J
    awful.key(
        { super_key, less_key }, 'j',
        function()
            awful.client.swap.global_bydirection('down')
        end,
        { description = 'swap with next client down', group = 'client - swap' }
    ),
    -- Swap with the next client right on "SUPER" + "LESS" + L
    awful.key(
        { super_key, less_key }, 'l',
        function()
            awful.client.swap.global_bydirection('right')
        end,
        { description = 'swap with next client right', group = 'client - swap' }
    ),
    -- Swap with the next client left on "SUPER" + "LESS" + H
    awful.key(
        { super_key, less_key }, 'h',
        function()
            awful.client.swap.global_bydirection('left')
        end,
        { description = 'swap with next client left', group = 'client - swap' }
    ),
    -- Swap with the next client by id on "SUPER" + "LESS" + TAB
    awful.key(
        { super_key, less_key }, 'Tab',
        function()
            awful.client.swap.byidx(1)
        end,
        { description = 'swap with next client by id', group = 'client - swap' }
    ),
    -- Swap with the previous client by id on "SUPER" + "MORE" + "LESS" + TAB
    awful.key(
        { super_key, more_key, less_key }, 'Tab',
        function()
            awful.client.swap.byidx(-1)
        end,
        { description = 'swap with previous client by id', group = 'client - swap' }
    ),
    --#endregion

    --#region Screen

    -- Focus next screen on "SUPER" + P
    awful.key(
        { super_key }, 'p',
        function()
            awful.screen.focus_relative(1)
        end,
        { description = 'focus next screen', group = 'screen - focus' }
    ),
    -- Focus previous screen on "SUPER" + O
    awful.key(
        { super_key }, 'o',
        function()
            awful.screen.focus_relative(-1)
        end,
        { description = 'focus previous screen', group = 'screen - focus' }
    ),
    -- Increase brightness on BRIGHTNESS UP
    awful.key(
        { }, 'XF86MonBrightnessDown',
        function()
            utils_apps.increase_brightness(-5)
        end,
        { description = 'Decrease brightness by 5%', group = 'screen - brightness' }
    ),
    -- Decrease brightness on BRIGHTNESS DOWN
    awful.key(
        { }, 'XF86MonBrightnessUp',
        function()
            utils_apps.increase_brightness(5)
        end,
        { description = 'Increase brightness by 5%', group = 'screen - brightness' }
    ),
    --#endregion

    --#region Launcher

    -- Terminal on "SUPER" + ENTER
    awful.key(
        { super_key }, 'Return',
        function()
            awful.spawn(terminal)
        end,
        { description = 'open a terminal', group = 'launcher' }
    ),
    -- Run launcher on "SUPER" + R
    awful.key(
        { super_key }, 'r',
        function()
            awful.util.spawn(user_apps.default_apps.run_menu)
        end,
        { description = 'open run launcher', group = 'launcher' }
    ),
    -- Menu on "SUPER" + W
    awful.key(
        { super_key }, 'w',
        function()
            user_menu:show()
        end,
        { description = 'open main menu', group = 'launcher' }
    ),
    --#endregion

    --#region Tiled layout manipulation manipulation

    -- Select next layout type on "SUPER" + SPACE
    awful.key(
        { super_key }, 'space',
        function()
            awful.layout.inc(1)
        end,
        { description = 'select next', group = 'layout - type' }
    ),
    -- Select previous layout type on "SUPER" + "LESS" + SPACE
    awful.key(
        { super_key, less_key }, 'space',
        function()
            awful.layout.inc(-1)
        end,
        { description = 'select previous', group = 'layout - type' }
    ),
    -- Increase the number of master clients on "SUPER" + "MORE" + K
    awful.key(
        { super_key, more_key }, 'k',
        function()
            awful.tag.incnmaster( 1, nil, true)
        end,
        { description = 'increase number of master clients', group = 'layout - type' }
    ),
    -- Decrease the number of master clients on "SUPER" + "MORE" + J
    awful.key(
        { super_key, more_key }, 'j',
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = 'decrease number of master clients', group = 'layout - type' }
    ),
    -- Increase master width on "SUPER" + "MORE" + L
    awful.key(
        { super_key, more_key }, 'l',
        function()
            awful.tag.incmwfact(resize_master_val)
        end,
        { description = 'increase master width factor', group = 'layout - size' }
    ),
    -- Decrease master width on "SUPER" + "MORE" + H
    awful.key(
        { super_key, more_key }, 'h',
        function()
            awful.tag.incmwfact(-resize_master_val)
        end,
        { description = 'decrease master width factor', group = 'layout - size' }
    ),
    --#endregion

    --#region Tags

    -- Swap between previous and current tag "SUPER" + ESC
    awful.key(
        { super_key }, 'Escape',
        awful.tag.history.restore,
        { description = 'restore previous tag', group = 'tag - display' }
    ),
    -- All other tag related keys will be added later

    --#endregion

    --#region Audio

    -- Toggle media on MEDIA PLAY/PAUSE
    awful.key(
        { }, 'XF86AudioPlay',
        function()
            utils_apps.media_toggle()
        end,
        { description = 'play / pause media', group = 'utilities - media' }
    ),

    -- Next media on MEDIA NEXT
    awful.key(
        { }, 'XF86AudioNext',
        function()
            utils_apps.media_next()
        end,
        { description = 'next media', group = 'utilities - media' }
    ),

    -- Previous media on MEDIA PREVIOUS
    awful.key(
        { }, 'XF86AudioPrev',
        function()
            utils_apps.media_previous()
        end,
        { description = 'previous media', group = 'utilities - media' }
    ),

    --#endregion
}
-- Add all other tag related keys
for _, tag_key in ipairs(all_tag_keys) do
    table.insert(global_keys, tag_key)
end


return {
    keys = global_keys,
    buttons = global_buttons
}
