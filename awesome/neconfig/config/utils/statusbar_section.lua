-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')


-- Container for class members
local statusbar_section = {}


function statusbar_section:new(args)
    local widget = args.widget
    local style = args.style or {}
    local size = args.size or beautiful.get_font_height(beautiful.font)
    local direction = args.direction or 'horizontal'
    local use_real_clip = args.use_real_clip
    local type = args.type or 'toolbar'
    local screen = args.screen


    local size_constraint = (direction == 'horizontal') and 'height' or 'width'

    local final_widget = {
        {
            widget,

            widget = wibox.container.background,
            ['forced_' .. size_constraint] = size
        },

        widget = wibox.container.background,
        bg = style.bg,
        shape = style.shape,
        shape_clip = true,
    }

    local final_shape
    if use_real_clip == nil or use_real_clip then
        final_shape = style.shape
    else
        final_shape = require('gears').shape.rectangle
    end


    self = awful.popup {
        screen = screen,
        bg = '#00000000',
        shape = final_shape,
        widget = final_widget,
        type = type
    }

    return self
end




return setmetatable(
    {},
    { __call = function(_,...) return statusbar_section:new(...) end }
)
