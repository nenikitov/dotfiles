-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_apps = require('neconfig.user.config.user_apps')


-- Container for functions
local utils_apps = {}

--- Increase or decrease brightness by using a tool set up in the user conf files
---@param step number Increment or decrement value
function utils_apps.increase_brightness(step)
    awful.spawn.with_line_callback(
        user_apps.utilities.brightness_get,
        {
            stdout = function(current_brightness)
                current_brightness = math.floor(current_brightness / step) * step
                current_brightness = current_brightness + step


                utils_apps.brightness_set(current_brightness)
            end
        }
    )
end

function utils_apps.brightness_set(value)
    value = math.min(100, math.max(1, value))

    awful.spawn.with_shell(
        string.format(
            user_apps.utilities.brightness_set,
            value
        )
    );

    awesome.emit_signal(
        'custom::brightness_change',
        value
    )
end

function utils_apps.take_screenshot()
    
end

return utils_apps
