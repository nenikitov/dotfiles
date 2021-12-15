-- Load libraries
local beautiful = require('beautiful')
local gears = require('gears')
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
widget_utils.create_progress_bar = function(args)
    local max_value = args.max_value or 1
    local bar_thickness = args.bar_thickness
    local circle_radius = args.circle_radius
    local target_thickness = args.target_thickness
    local target_length = args.target_length
    local orientation = args.orientation or 'horizontal'
    local on_change = args.on_change or function(value) end

    local half_height = target_thickness / 2
    local margin = half_height - bar_thickness
    local direction = (orientation == 'horizontal') and 'north' or 'west'

    local progress_widget = wibox.widget {
        widget = wibox.widget.progressbar,

        max_value = max_value,

        forced_height = target_thickness,
        forced_width = target_length,

        bar_shape = function(cr, w, h)
            return gears.shape.circle(cr, w * 2, h, circle_radius)
        end,

        clip = false,

        margins = {
            top = margin,
            bottom = margin
        },
        paddings = {
            left = circle_radius,
            right = circle_radius
        }
    }

    -- Move outside
    awesome.connect_signal(
        'custom::brightness_change',
        function(value)
            progress_widget.value = value
        end
    )

    progress_widget:connect_signal(
        'button::press',
        function(self, lx, ly, button, mod, widget_results)
            if (button == 1) then
                local bar_width = widget_results.widget_width - circle_radius * 2
                local mouse_on_bar_x = lx - circle_radius
                local value = math.max(0, math.min(1, mouse_on_bar_x / bar_width))
                self.value = value * max_value
                on_change(self.value)
            end
        end
    )

    return wibox.widget {
        progress_widget,

        direction = direction,
        layout = wibox.container.rotate
    }
end


return widget_utils
