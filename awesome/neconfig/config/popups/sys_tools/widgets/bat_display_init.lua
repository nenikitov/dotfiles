-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')
local widget_utils = require('neconfig.config.utils.widget_utils')


local battery_icon = widget_utils.create_text_icon(icons.battery0)
local battery_info = wibox.widget.textbox()
local time_icon = widget_utils.create_text_icon(icons.hourglass)
local time_info = wibox.widget.textbox()


lain.widget.bat {
    notify = 'off',
    timeout = 10,

    settings = function()
        local status = bat_now.ac_status
        local percent = bat_now.perc
        local remaining = bat_now.time

        if (string.match(percent, '%d+')) then
            local value = tonumber(percent)

            battery_info.text = percent .. ' %'

            if (status == 1) then
                -- Charging
                battery_icon.text = icons.charging
            elseif (value >= 80) then
                -- 80 to 100 %
                battery_icon.text = icons.battery4
            elseif (value >= 60) then
                -- 60 to 79 %
                battery_icon.text = icons.battery3
            elseif (value >= 40) then
                -- 40 to 59 %
                battery_icon.text = icons.battery2
            elseif (value > 20) then
                -- 20 to 39 %
                battery_icon.text = icons.battery1
            else
                -- 01 to 19 %
                battery_icon.text = icons.battery0
            end
        else
            battery_info.text = percent
        end

        time_info.text = remaining
    end
}

return wibox.widget {
    {
        battery_icon,
        battery_info,

        layout = wibox.layout.fixed.horizontal
    },
    {
        time_icon,
        time_info,

        layout = wibox.layout.fixed.horizontal
    },

    layout = wibox.layout.flex.horizontal
}
