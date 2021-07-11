-- RC.LUA
-- Loading modules
local lain = require("lain")
local freedesktop = require("freedesktop")
-- Autostart
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end
run_once({ "urxvtd", "unclutter -root" })
-- Freedesktop menu setup
local mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}
-- Hide menu when mouse leaves it
mymainmenu.wibox:connect_signal("mouse::leave", function() mymainmenu:hide() end)
-- Pass the screen to init to the theme
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)


-- THEME
-- Loading modules
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local os = os
-- Setting up the screen from the theme
function theme.at_screen_connect(s)
    ...
end
