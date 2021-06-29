-- Standard Awesome libraries
local awful = require("awful")

-- Autostart applications
awful.spawn.with_shell("picom --xrender-sync-fence")
awful.spawn.with_shell("nitrogen --restore")
