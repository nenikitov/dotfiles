-- Load libraries
local wibox = require('wibox')
local gears = require('gears')

-- Other variables
local iconfont = 'Font Awesome 5 Free-Solid-900'


-- Generate an text widget with an icon
function create_icon(icon, size, color)
    return wibox.widget {
        font = iconfont .. ' ' .. size,
        markup = ' <span color=' .. color ..'>' .. icon .. '</span> ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end


-- Create a padding for a widget
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

-- Generate a pill shape that can contain widgets
function create_pill(contents, color, radius, vertical_padding, horizontal_padding, right_margin)
    return {
        {
            {
                pad_widget(contents, vertical_padding, horizontal_padding, vertical_padding, horizontal_padding)
            },
            widget = wibox.container.background,
    
            bg = color,
            shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, radius) end,
            shape_clip = true
        },

        widget = wibox.container.margin,

        right = right_margin
    }
end
