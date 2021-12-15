-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_conf_apps = require('neconfig.config.user.user_conf_apps')


-- Container for functions
local app_utils = {}

--- Increase or descrease brightness by using a tool set up in the user conf files
---@param step number Increment or decrement value
app_utils.increase_brightness = function(step)
    awful.spawn.with_line_callback(
        user_conf_apps.utils.get_brightness,
        {
            stdout = function(current_brightness)
                current_brightness = math.floor(current_brightness / step) * step
                current_brightness = current_brightness + step

                app_utils.set_brightness(current_brightness)
            end
        }
    )
end

app_utils.set_brightness = function(value)
    value = math.min(100, math.max(1, value))

    awful.spawn.with_shell(
        string.format(
            user_conf_apps.utils.set_brightness,
            value
        )
    );

    awesome.emit_signal(
        'custom::brightness_change',
        value
    )
end

app_utils.take_screenshot = function()
    
end

return app_utils
