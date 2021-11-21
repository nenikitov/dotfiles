-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Custom modules
local icons = require('neconfig.config.utils.icons')

local ethernet_icon = ''
local wifi_icon = ''

local net_widget = wibox.widget.textbox()


lain.widget.net {
    notify = 'off',
    wifi_state = 'on',
    eth_state = 'on',
    iface = { 'eth0', 'wlan0' },

    settings = function()
        local ethernet = net_now.devices['eth0']
        if (ethernet) then
            ethernet_icon = icons.ethernet
        else
            ethernet_icon = ''
        end

        -- TODO test on wifi
        -- TODO set correct wifi interface name
        -- TODO find wifi icons for different connectivity status
        local wifi = net_now.devices['wlan0']
        if (wifi) then
            local signal = wifi.signal or -100

            if (signal < -90) then
                wifi_icon = ''
            elseif (signal < -80) then
                wifi_icon = 'bad'
            elseif (signal < -70) then
                wifi_icon = 'weak'
            elseif (signal < 67) then
                wifi_icon = 'ok'
            elseif (signal < 60) then
                wifi_icon = 'good'
            elseif (signal < 50) then
                wifi_icon = 'excellent'
            else
                wifi_icon = 'perfect'
            end
        end

        net_widget.text = ethernet_icon .. wifi_icon
    end
}

return net_widget