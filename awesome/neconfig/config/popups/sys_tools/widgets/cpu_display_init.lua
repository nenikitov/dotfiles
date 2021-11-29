-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Custom modules
local icons = require('neconfig.config.utils.icons')
local user_vars_conf = require('neconfig.config.user.user_vars_conf')
require('neconfig.config.utils.widget_utils')

-- Get variables
local cpu_thermal_zone = user_vars_conf.statusbar.widgets.sys_tools.cpu_thermal_zone


local cpu_icon = create_text_icon(icons.cpu)
local cpu_info = wibox.widget.textbox()
local temp_icon = create_text_icon(icons.temperature)
local temp_info = wibox.widget.textbox()


lain.widget.cpu {
    timeout = 1,

    settings = function()
        local usage = cpu_now.usage

        cpu_info.text = usage .. ' %'
    end
}
lain.widget.temp {
    timeout = 1,
    -- TODO Find the correct file
    tempfile = '/sys/devices/virtual/thermal/' .. cpu_thermal_zone .. '/temp',

    settings = function ()
        local temp = coretemp_now

        temp_info.text = temp .. ' C'
    end
}

return wibox.widget {
    {
        cpu_icon,
        cpu_info,

        layout = wibox.layout.fixed.horizontal
    },
    {
        temp_icon,
        temp_info,

        layout = wibox.layout.fixed.horizontal
    },

    layout = wibox.layout.flex.horizontal
}
