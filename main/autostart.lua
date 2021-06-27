local awful = require("awful")

awful.spawn.with_shell("picom --xrender-sync-fence")
awful.spawn.with_shell("nitrogen --restore")
