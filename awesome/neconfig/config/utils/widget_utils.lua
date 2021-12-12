-- Load libraries
local beautiful = require('beautiful')
local gears = require('gears')
local vicious = require('vicious')
local wibox = require('wibox')


-- Container for functions
local widget_utils = {}

--- Generate a rounded rectangle shape with a radius
---@param radius number Radius
---@return function
widget_utils.r_rect = function(radius)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end


--- Shrink widget horizontally to the given size
---@param contents table Contents to put inside
---@param size number Width
---@return table
widget_utils.set_width_widget = function(contents, size)
    return {
        contents,

        widget = wibox.container.background,
        forced_width = size
    }
end
--- Shrink widget vertically to the given size
---@param contents table Contents to put inside
---@param size number Height
---@return table
widget_utils.set_height_widget = function(contents, size)
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
---@return table
widget_utils.pad_widget = function(contents, top, right, bottom, left)
    return {
        contents,

        widget = wibox.container.margin,

        top = top,
        right = right,
        bottom = bottom,
        left = left
    }
end


widget_utils.create_text_icon = function(icon)
    local font_height = beautiful.get_font_height(beautiful.font)

    return wibox.widget {
        markup = icon,
        forced_width = font_height * 1.5,
        align = 'center',

        widget = wibox.widget.textbox
    }
end


widget_utils.create_vicious_widget = function(type, timeout, format, icon, args)
    local info_widget = wibox.widget.textbox()

    vicious.cache(type)
    vicious.register(info_widget, type, format, timeout, args)

    if (icon ~= nil)
    then
        local font_height = beautiful.get_font_height(beautiful.font)
        local icon_widget = wibox.widget {
            markup = icon,
            forced_width = font_height * 1.1,

            widget = wibox.widget.textbox
        }

        return wibox.widget {
            icon_widget,
            info_widget,

            layout = wibox.layout.fixed.horizontal
        }
    else
        return info_widget
    end
end

return widget_utils
