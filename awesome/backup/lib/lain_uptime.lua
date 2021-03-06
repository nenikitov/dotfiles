-- Load libraries
local helpers = require('lain.helpers')
local wibox = require('wibox')
local match, floor = string.match, math.floor


local function uptime_widget(args)
    args = args or {}

    local uptime = { widget = args.widget or wibox.widget.textbox() }
    local timeout = args.timeout or 1
    local settings = args.settings or function() end

    function uptime.update()
        uptime_now = {}

        local line = helpers.first_line('/proc/uptime')
        local secs = floor(match(line, '^[0-9.]+'))

        uptime_now.tot_sec = secs
        uptime_now.tot_min = floor(secs / 60)
        uptime_now.tot_hr = floor(uptime_now.tot_min / 60)
        uptime_now.tot_day = floor(uptime_now.tot_hr / 24)

        uptime_now.sec = uptime_now.tot_sec % 60
        uptime_now.min = uptime_now.tot_min % 60
        uptime_now.hr = uptime_now.tot_hr % 24

        widget = uptime.widget
        settings()
    end

    helpers.newtimer('uptime', timeout, uptime.update)

    return uptime
end

return uptime_widget
