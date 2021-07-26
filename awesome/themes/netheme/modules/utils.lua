local wibox = require("wibox")
local gears = require("gears")
local iconfont = "Font Awesome 5 Free-Solid-900"
local icons = {
    -- This table corresponds to unicode indexes of icons in Font Awesome. It may be different for other icon fonts
    ["home"]     = "\u{f015}",
    ["terminal"] = "\u{f120}",
    ["code"]     = "\u{f121}",
    ["brush"]    = "\u{f1fc}",
    ["study"]    = "\u{f19d}",
    ["folder"]   = "\u{f07b}",
}

function create_icon(icon, size, color)
    return wibox.widget {
        font = iconfont .. ' ' .. size,
        markup = ' <span color="' .. color ..'">' .. iconlist[icon] .. '</span> ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

function create_pill(contents, color, radius, margin, padding)
    local margin_r = margin and 4 or 0
    local padding_val = padding and 4 or 0

    if (contents ~= nil)
    then
        return {
            {
                {
                    contents,
        
                    widget = wibox.container.margin,
        
                    left = padding_val,
                    right = padding_val,
                    top = padding_val,
                    bottom = padding_val
                },
                widget = wibox.container.background,
        
                bg = color,
                shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, radius) end,
                shape_clip = true
            },

            widget = wibox.container.margin,

            right = margin_r
        }
    else
        return wibox.widget {}
    end
end
