-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
-- Global variables
local modkey = rc.uservars.modkey
local terminal = rc.uservars.terminal

function getglobalkeys()
    -- Bind keyboard keys to interact with Awesome WM itself
    local globalkeys = gears.table.join(
        -- {{{ Awesome controls
        -- Show all bind on MOD + S
        awful.key(
            { modkey }, "s",
            hotkeys_popup.show_help,
            { description = "show help", group = "awesome" }
        ),
        --- Menu on MOD + W
        awful.key(
            { modkey }, "w",
            function ()
                rc.menu:show()
            end,
            { description = "show main menu", group = "awesome" }
        ),
        -- Reload Awesome on MOD + CTRL + R
        awful.key(
            { modkey, "Control" }, "r",
            awesome.restart,
            { description = "reload awesome", group = "awesome" }
        ),
        -- Quit Awesome on MOD + SHIFT + Q
        awful.key(
            { modkey, "Shift" }, "q",
            awesome.quit,
            { description = "quit awesome", group = "awesome" }
        ),
        -- }}}

        -- {{{ Tag interaction
        -- Go to next tag on MOD + RIGHT ARROW
        awful.key(
            { modkey }, "Right",
            awful.tag.viewnext,
            { description = "view next", group = "tag" }
        ),
        -- Go to previous tag on MOD + LEFT ARROW
        awful.key(
            { modkey },    "Left",
            awful.tag.viewprev,
            { description = "view previous", group = "tag" }
        ),
        -- Go back in tag interaction history on MOD + ESC
        awful.key(
            { modkey }, "Escape",
            awful.tag.history.restore,
            { description = "go back", group = "tag" }
        ),
        -- }}}

        -- {{{ Client focus manipulation
        -- Focus next client on MOD + J
        awful.key(
            { modkey }, "j",
            function ()
                awful.client.focus.byidx( 1)
            end,
            { description = "focus next by index", group = "client" }
        ),
        -- Focus previous client on MOD + K
        awful.key(
            { modkey }, "k",
            function ()
                awful.client.focus.byidx(-1)
            end,
            { description = "focus previous by index", group = "client" }
        ),
        -- }}}
    
        -- {{{ Client manipulation
        -- Swap the current client with the next one in the wibar on MOD + SHIFT + J
        awful.key(
            { modkey, "Shift" }, "j",
            function ()
                awful.client.swap.byidx(1)
            end,
            { description = "swap with next client by index", group = "client" }
        ),
        -- Swap the current client with the previous one in the wibar on MOD + SHIFT + K
        awful.key(
            { modkey, "Shift" }, "k",
            function ()
                awful.client.swap.byidx(-1)
            end,
            { description = "swap with previous client by index", group = "client" }
        ),
        -- Focus urgent client on MOD + U
        awful.key(
            { modkey }, "u",
            awful.client.urgent.jumpto,
            { description = "jump to urgent client", group = "client" }
        ),
        -- Focus previously used client on MOD + TAB
        awful.key(
            { modkey }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            { description = "go back", group = "client" }
        ),
        -- Restore minimized on MOD + CTRL + N
        awful.key(
            { modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                if c then
                    c:emit_signal(
                        "request::activate",
                        "key.unminimize",
                        {raise = true}
                    )
                end
            end,
            { description = "restore minimized", group = "client" }
        ),
        -- }}}
    
        -- {{{ Screen
        -- Focus next screen on MOD + CTRL + J
        awful.key(
            { modkey, "Control" }, "j",
            function ()
                awful.screen.focus_relative(1)
            end,
            { description = "focus the next screen", group = "screen" }
        ),
        -- Focus previous screen on MOD + CTRL + K
        awful.key(
            { modkey, "Control" }, "k",
            function ()
                awful.screen.focus_relative(-1)
            end,
            { description = "focus the previous screen", group = "screen" }
        ),
        -- }}}


        -- {{{ Launcher
        -- Terminal on MOD + ENTER
        awful.key(
            { modkey }, "Return",
            function ()
                awful.spawn(terminal)
            end,
            { description = "open a terminal", group = "launcher" }
        ),
        -- ROFI launcher on MOD + R
        awful.key(
            { modkey }, "r",
            function ()
                awful.util.spawn("rofi -show drun")
            end,
            { description = "open ROFI launcher", group = "launcher" }
        ),
        -- LUA code on MOD + X
        awful.key(
            { modkey }, "x",
            function ()
                awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().promptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            { description = "lua execute prompt", group = "awesome" }
        ),
        -- Menubar on MOD + P
        awful.key(
            { modkey }, "p",
            function()
                menubar.show()
            end,
            { description = "show the menubar", group = "launcher" }
        ),
        -- }}}

        -- {{{ Tiled grid manipulation manipulation
        -- Increase master width on MOD + L
        awful.key(
            { modkey }, "l",
            function ()
                awful.tag.incmwfact(0.05)
            end,
            { description = "increase master width factor", group = "layout" }
        ),
        -- Decrease master width on MOD + H
        awful.key(
            { modkey }, "h",
            function ()
                awful.tag.incmwfact(-0.05)
            end,
            { description = "decrease master width factor", group = "layout" }
        ),
        -- Increase the number of master clients on MOD + SHIFT + H
        awful.key(
            { modkey, "Shift" }, "h",
            function ()
                awful.tag.incnmaster( 1, nil, true)
            end,
            { description = "increase the number of master clients", group = "layout" }
        ),
        -- Decrease the number of master clients on MOD + SHIFT + L
        awful.key(
            { modkey, "Shift" }, "l",
            function ()
                awful.tag.incnmaster(-1, nil, true)
            end,
            { description = "decrease the number of master clients", group = "layout" }
        ),
        -- Increase number of columns on MOD + CTRL + H
        awful.key(
            { modkey, "Control" }, "h",
            function ()
                awful.tag.incncol( 1, nil, true)
            end,
            { description = "increase the number of columns", group = "layout" }
        ),
        -- Decrease number of columns on MOD + CTRL + L
        awful.key(
            { modkey, "Control" }, "l",
            function ()
                awful.tag.incncol(-1, nil, true)
            end,
            { description = "decrease the number of columns", group = "layout" }
        ),
        -- }}}

        -- {{{ Layout manipulation
        -- Select next layout type on MOD + SPACE
        awful.key(
            { modkey }, "space",
            function ()
                awful.layout.inc(1)
            end,
            { description = "select next", group = "layout" }
        ),
        -- Select previous layout type on MOD + SHIFT + SPACE
        awful.key(
            { modkey, "Shift" }, "space",
            function ()
                awful.layout.inc(-1)
            end,
            { description = "select previous", group = "layout" }
        )
        -- }}}
    )

    return globalkeys
end

return setmetatable(
    {},
    {  __call = function(_, ...) return getglobalkeys(...) end }
)
