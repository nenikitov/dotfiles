-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')
local statusbar_user_conf = require('neconfig.config.user.statusbar_user_conf')
local widget_utils = require('neconfig.config.utils.widget_utils')

-- Get variables
-- local cpu_thermal_zone = statusbar_user_conf.widgets.sys_tools.cpu_thermal_zone
local cpu_thermal_zone = 'thermal_zone1'

local cpu_icon = widget_utils.create_text_widget(icons.cpu)
local cpu_info = wibox.widget.textbox()
local temp_icon = widget_utils.create_text_widget(icons.temperature)
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
