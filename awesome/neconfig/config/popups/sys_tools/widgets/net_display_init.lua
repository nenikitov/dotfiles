-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Custom modules
local icons = require('neconfig.config.utils.icons')
require('neconfig.config.utils.widget_utils')


local download_icon = create_text_icon(icons.download)
local download_info = wibox.widget.textbox()
local upload_icon = create_text_icon(icons.upload)
local upload_info = wibox.widget.textbox()


lain.widget.net {
    notify = 'off',
    timeout = 1,
    wifi_state = 'on',
    eth_state = 'on',
    --iface = { 'eth0', 'wlan0' },
    units = 1024^2,

    settings = function()
        local download = net_now.received
        local upload = net_now.sent

        download_info.text = download .. ' MB/s'
        upload_info.text = upload .. ' MB/s'
    end
}

return wibox.widget {
    {
        download_icon,
        download_info,

        layout = wibox.layout.fixed.horizontal
    },
    {
        upload_icon,
        upload_info,

        layout = wibox.layout.fixed.horizontal
    },

    layout = wibox.layout.flex.horizontal
}