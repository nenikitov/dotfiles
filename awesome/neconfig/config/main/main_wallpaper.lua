-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')


-- Set wallpaper
screen.connect_signal(
    'request::wallpaper',
    function(s)
        if beautiful.wallpaper and user_look_desktop.load_awesome_wallpaper then
            awful.wallpaper {
                screen = s,
                widget = {
                    {
                        image = beautiful.wallpaper,
                        upscale = true,
                        downscale = true,

                        widget = wibox.widget.imagebox
                    },

                    valign = 'center',
                    halign = 'center',
                    tiled = false,

                    widget = wibox.container.tile
                }
            }
        end
    end
)
