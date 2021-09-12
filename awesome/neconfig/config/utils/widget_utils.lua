-- Load libraries
local wibox = require('wibox')
local gears = require('gears')


--- Generate a rounded rectangle shape
---@param radius number
---@return function
function r_rect(radius)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end


--- Clip the widget so it fits the given shape
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

--- Shrink widget horizontally to the given size
---@param contents widget
---@param size number
---@return widget
function set_width_widget(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_width = size
    }
end

--- Shrink widget vertically to the given size
---@param contents widget
---@param size number
---@return widget
function set_height_widget(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_height = size
    }
end


--- Shrink widget to the given size
---@param contents widget
---@param width number
---@param height number
---@return widget
function set_size_widget(contents, width, height)
    return {
        contents,

        widget = wibox.container.background,
        forced_height = height,
        forced_width = width
    }
end

--- Create a padding for a widget
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
