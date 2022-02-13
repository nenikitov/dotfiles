-- Load libraries local gears = require('gears')
local naughty = require('naughty')
local gears = require('gears')
local lgi = require('lgi')
local gdk = lgi.require('Gdk', '3.0')
-- Load custom modules
local utils_shapes = require('neconfig.config.utils.utils_shapes')


-- Container for functions
local utils_colors = {}


function utils_colors.get_client_side_color(client, side)
    local offset = 1
    local pixel_skip = 50

    local direction = utils_shapes.direction_of_side(side)
    local size_property = utils_shapes.size_prop_of_direction(direction)
    local opp_size_property = utils_shapes.size_prop_of_direction(utils_shapes.perp_direction(direction))
    local pos_property = utils_shapes.pos_prop_of_direction(direction)
    local opp_pos_property = utils_shapes.pos_prop_of_direction(utils_shapes.perp_direction(direction))

    local content = gears.surface(client.content)
    local width, height = gears.surface.get_size(content)
    local geometry = {
        width = width,
        height = height
    }

    local colors = {}

    local pos = {
        [pos_property] = offset,
        [opp_pos_property] = (side == 'top' or side == 'left') and (offset) or (geometry[opp_size_property] - offset)
    }
    for length = offset, geometry[size_property] - offset, pixel_skip do
        pos[pos_property] = length

        local pb = gdk.pixbuf_get_from_surface(content, pos.x, pos.y, 1, 1)

        if pb then
            local bytes = pb:get_pixels()
            local color = '#' .. bytes:gsub('.', function(c) return ('%02x'):format(c:byte()) end)

            if colors[color] then
                colors[color] = colors[color] + 1
            else
                colors[color] = 1
            end
        end
    end

    local max_count = 0
    local max_color = nil
    for color, count in pairs(colors) do
        if count > max_count then
            max_count = count
            max_color = color
        end
    end

    return max_color
end


return utils_colors
