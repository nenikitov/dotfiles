local wibox = require("wibox")
local iconlist = require("modules.deco.iconlist")

local iconfont = "Font Awesome 5 Free-Solid-900"

function createicon(icon, size, color)
    return wibox.widget{
        font = iconfont .. ' ' .. size,
        markup = ' <span color="' .. color ..'">' .. iconlist[icon] .. '</span> ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end