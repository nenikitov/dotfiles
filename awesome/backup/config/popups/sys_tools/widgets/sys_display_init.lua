-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')
local uptime_widget = require('neconfig.lib.lain_uptime')
local widget_utils = require('neconfig.config.utils.widget_utils')


local uptime_icon = widget_utils.create_text_widget(icons.clock)
local uptime_info = wibox.widget.textbox()
local drive_icon = widget_utils.create_text_widget(icons.hard_drive)
local drive_info = wibox.widget.textbox()


uptime_widget {
    timeout = 20,

    settings = function ()
        local hr = uptime_now.tot_hr
        local min = string.format('%02d', uptime_now.min)
        uptime_info.text = hr .. ':' .. min
    end
}
lain.widget.fs {
    timeout = 120,

    settings = function ()
        local used = string.format('%.1f', fs_now['/'].used) .. ' ' .. fs_now['/'].units
        drive_info.text = used
    end
}

return wibox.widget {
    {
        uptime_icon,
        uptime_info,

        layout = wibox.layout.fixed.horizontal
    },
    {
        drive_icon,
        drive_info,

        layout = wibox.layout.fixed.horizontal
    },

    layout = wibox.layout.flex.horizontal
}