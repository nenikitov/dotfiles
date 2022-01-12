-- Load libraries
local awful = require('awful')
-- Load custom modules
local apps_user_conf = require('neconfig.config.user.apps_user_conf')


-- Container for functions
local app_utils = {}

--- Increase or descrease brightness by using a tool set up in the user conf files
---@param step number Increment or decrement value
function app_utils.increase_brightness(step)
    awful.spawn.with_line_callback(
        apps_user_conf.utils.get_brightness,
        {
            stdout = function(current_brightness)
                current_brightness = math.floor(current_brightness / step) * step
                current_brightness = current_brightness + step

                app_utils.set_brightness(current_brightness)
            end
        }
    )
end

function app_utils.set_brightness(value)
    value = math.min(100, math.max(1, value))

    awful.spawn.with_shell(
        string.format(
            apps_user_conf.utils.set_brightness,
            value
        )
    );

    awesome.emit_signal(
        'custom::brightness_change',
        value
    )
end

function app_utils.take_screenshot()
    
end

return app_utils
