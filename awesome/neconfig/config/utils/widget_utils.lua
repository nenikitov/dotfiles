-- Load libraries
local wibox = require('wibox')
local gears = require('gears')


--- Generate a rounded rectangle shape with a radius
---@param radius number Radius
---@return function
function r_rect(radius)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end


--- Shrink widget horizontally to the given size
---@param contents table Contents to put inside
---@param size number Width
---@return widget
function set_width_widget(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_width = size
    }
end
--- Shrink widget vertically to the given size
---@param contents table Contents to put inside
---@param size number Height
---@return widget
function set_height_widget(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_height = size
    }
end


--- Create a padding for a widget
---@param contents table Contents to put inside
---@param top number Pad on top
---@param right number Pad on right
---@param bottom number Pad on bottom
---@param left number Pad on left
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


-- ? Not needed?
--[[
--- Clip the widget so it fits the given shape
---@param contents table Contents to put inside
---@param shape gears.shape Shape used to clip
---@return table
function clip_widget(contents, shape)
    return {
        contents,

        widget = wibox.container.background,
        shape = shape,
        shape_clip = true
    }
end


--- Shrink widget to the given size
---@param contents table Contents to put inside
---@param width number Height and width
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


--- Put the widget inside of the square
---@param contents table Contents to put inside
---@param size number Width and height
---@param padding number Padding
---@return table
function square_widget(contents, size, padding)
    return {
        contents,

        widget = wibox.container.margin,

        top = padding,
        right = padding,
        bottom = padding,
        left = padding,
        forced_width = size,
        forced_height = size,
    }
end
]]
