local wibox = require("wibox")
local gears = require("gears")
local iconlist = require("modules.deco.iconlist")

local iconfont = "Font Awesome 5 Free-Solid-900"

function create_icon(icon, size, color)
    return wibox.widget {
        font = iconfont .. ' ' .. size,
        markup = ' <span color="' .. color ..'">' .. iconlist[icon] .. '</span> ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

function create_pill(contents, color, margin)
    local margin_r = margin and 8 or 0

    if (contents ~= nil)
    then
        return {
            {
                {
                    contents,
        
                    widget = wibox.container.margin,
        
                    left = 10,
                    right = 10,
                    top = 2,
                    bottom = 2
                },
                widget = wibox.container.background,
        
                bg = color,
                shape = gears.shape.rounded_rect
            },

            widget = wibox.container.margin,

            right = margin_r
        }
    else
        return wibox.widget {}
    end
end
