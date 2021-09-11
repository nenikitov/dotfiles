-- Load libraries
local wibox = require('wibox')
local gears = require('gears')


---Generate a rounded rectangle shape
---@param radius number
---@return function
function r_rect(radius)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end


---Clip the widget so it fits the given shape
---@param contents widget
---@param shape gears.shape
---@return table
function clip_widget(contents, shape)
    return {
        contents,

        widget = wibox.container.background,
        shape = shape,
        shape_clip = true
    }
end

---Shrink widget horizontally to the given size
---@param contents widget
---@param size number
---@return widget
function resize_hor_widget(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_width = size
    }
end

---Shrink widget vertically to the given size
---@param contents widget
---@param size number
---@return widget
function resize_vert_widget(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_height = size
    }
end

---Create a padding for a widget
---@param contents widget
---@param top number
---@param right number
---@param bottom number
---@param left number
---@return widget
function pad_widget(contents, top, right, bottom, left)
    return {
        contents,

        widget = wibox.container.margin,

        top = top,
        right = right,
        bottom = bottom,
        left = left
    }
end

-- TODO remove?
-- Generate a pill shape that can contain widgets
function place_in_pill(contents, color, radius, vertical_padding, horizontal_padding, right_margin)
    local padded = pad_widget(contents, vertical_padding, horizontal_padding, vertical_padding, horizontal_padding)
    local with_bg = {
        padded,
        widget = wibox.container.background,
        bg = color,
        shape = r_rect(radius),
        shape_clip = true
    }
    local final = pad_widget(with_bg, 0, right_margin, 0, 0)

    return final
end
