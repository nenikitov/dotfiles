-- Load libraries local gears = require('gears')
local gears = require('gears')
local lgi = require('lgi')
local gdk = lgi.require('Gdk', '3.0')
-- Load custom modules
local utils_shapes = require('neconfig.config.utils.utils_shapes')


-- Container for functions
local utils_colors = {}


--#region Helper functions
local function to_linear_c(channel)
    if channel <= 0.04045 then
        return channel / 12.92
    else
        return ((channel + 0.055) / 1.055) ^ 2.4
    end
end
local function to_linear(color)
    local r, g, b = gears.color.parse_color(color)

    return to_linear_c(r), to_linear_c(g), to_linear_c(b)
end
local function get_luma(color)
    local r, g, b = to_linear(color)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
end
--#endregion


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


function utils_colors.get_contrast(col1, col2)
    local luma1 = get_luma(col1)
    local luma2 = get_luma(col2)

    return (math.max(luma1, luma2) + 0.05) / (math.min(luma1, luma2) + 0.05)
end


function utils_colors.get_most_contrast_color(bg_color, ...)
    local max_contrast = 0
    local max_contrast_color = nil
    for _, c in ipairs({...}) do
        local contrast = utils_colors.get_contrast(bg_color, c)

        if contrast > max_contrast then
            max_contrast = contrast
            max_contrast_color = c
        end
    end

    return max_contrast_color
end


return utils_colors
