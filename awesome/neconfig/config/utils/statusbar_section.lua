-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')


-- Container for class members
local statusbar_section = {}


function statusbar_section:new(args)
    local widget = args.widget
    local style = args.style or { shape = nil, bg = nil }
    local size = args.size or beautiful.get_font_height(beautiful.font)
    local size_constraint = args.size_constraint or 'height'
    local screen = args.screen


    local final_widget = {
        {
            widget,

            widget = wibox.container.background,
            ['forced_' .. size_constraint] = size
        },

        widget = wibox.container.background,
        shape = style.shape,
        shape_clip = true,
        bg = style.bg
    }

    self = awful.popup {
        screen = screen,
        bg = style.bg,
        shape = style.shape,
        widget = final_widget
    }

    return self
end




return setmetatable(
    {},
    { __call = function(_,...) return statusbar_section:new(...) end }
)
