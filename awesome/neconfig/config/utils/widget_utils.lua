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


widget_utils.create_text_widget = function(text)
    local font_height = beautiful.get_font_height(beautiful.font)

    return wibox.widget {
        markup = text,
        forced_width = font_height * 1.5,
        align = 'center',

        widget = wibox.widget.textbox
    }
end
widget_utils.create_progress_bar = function(bar_thickness, circle_radius, total_height)
    local half_height = total_height / 2
    local margin = half_height - bar_thickness

    local progress_widget = wibox.widget {
        max_value     = 1,
        value         = 0,
        forced_height = total_height,
        forced_width  = 100,
        widget        = wibox.widget.progressbar,
        clip = false,
        bar_shape = function(cr, w, h)
            return gears.shape.circle(cr, w * 2, h, circle_radius)
        end,
        margins = {
            top = margin,
            bottom = margin
        },
        paddings = {
            left = circle_radius,
            right = circle_radius
        }
    }

    progress_widget.update_value = function(value)
    end

    progress_widget:connect_signal(
        'button::press',
        function(self, lx, ly, button, mod, widget_results)
            local bar_width = widget_results.widget_width - circle_radius * 2
            local mouse_on_bar_x = lx - circle_radius
            local value = math.max(0, math.min(1, mouse_on_bar_x / bar_width))

            self.value = value
        end
    )

    return progress_widget
end


return widget_utils
