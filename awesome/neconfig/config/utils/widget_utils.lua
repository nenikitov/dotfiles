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
widget_utils.create_progress_bar = function(text)
    local font_height = beautiful.get_font_height(beautiful.font)
    local margin = font_height / 2 - 1
    local radius = font_height / 4

    local text_widget = widget_utils.create_text_widget(text)
    local percent_widget = wibox.widget {
        text = '100 %',
        widget = wibox.widget.textbox
    }
    local progress_widget = wibox.widget {
        max_value     = 1,
        value         = 0,
        forced_height = 1,
        forced_width  = 100,
        widget        = wibox.widget.progressbar,
        clip = false,
        bar_shape = function(cr, w, h)
            return gears.shape.circle(cr, w * 2, h, radius)
        end,
        margins = {
            top = margin,
            bottom = margin
        },
        paddings = {
            left = radius,
            right = radius
        }
    }
    progress_widget:connect_signal(
        'button::press',
        function(self, lx, ly, button, mods, widget_results)
            self.value = 0.5
            require('naughty').notify {
                text = tostring(widget_results.widget_width)
            }
        end
    )

    return wibox.widget {
        text_widget,
        progress_widget,
        percent_widget,

        layout = wibox.layout.align.horizontal
    }
end


return widget_utils
