-- Load libraries local gears = require('gears')
local gears = require('gears')
local lgi = require('lgi')
local gdk = lgi.require('Gdk', '3.0')
local naughty = require('naughty')
-- Load custom modules

test = true
-- Container for functions
local utils_colors = {}


function utils_colors.get_client_side_color(client, side)
    local content = gears.surface(client.content)
    if test then
        test = false
        gears.surface(client.content):write_to_png('/home/nenikitov/test.png')
    end
    local geometry = client:geometry()

    local pb = gdk.pixbuf_get_from_surface(content, 2, 2, 1, 1)
    local bytes = pb:get_pixels()

    local color = '#' .. bytes:gsub('.', function(c) return ('%02x'):format(c:byte()) end)

    return color
end


return utils_colors
