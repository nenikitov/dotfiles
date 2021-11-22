-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Custom modules
local icons = require('neconfig.config.utils.icons')
require('neconfig.config.utils.widget_utils')


local ram_icon = create_text_icon(icons.ram_module)
local ram_info = wibox.widget.textbox()
local swap_icon = create_text_icon(icons.swap)
local swap_info = wibox.widget.textbox()


lain.widget.mem {
    timeout = 1,

    settings = function()
        local ram = mem_now.used
        local swap = mem_now.swapused

        ram_info.text = ram .. ' Mb'
        swap_info.text = swap .. ' Mb'
    end
}

return wibox.widget {
    {
        ram_icon,
        ram_info,

        layout = wibox.layout.fixed.horizontal
    },
    {
        swap_icon,
        swap_info,

        layout = wibox.layout.fixed.horizontal
    },

    layout = wibox.layout.flex.horizontal
}
