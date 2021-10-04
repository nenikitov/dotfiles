-- Load libraries
local gears = require('gears')
local beautiful = require('beautiful')


-- Set wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. changing the resolution)
screen.connect_signal('property::geometry', set_wallpaper)
