local awful = require('awful')
local user_conf_apps = require('neconfig.config.user.user_conf_apps')

function increase_brightness(step)
    awful.spawn.with_line_callback(
            user_conf_apps.utils.get_brightness,
            {
                stdout = function(current_brightness)
                    current_brightness = math.floor(current_brightness / step) * step
                    current_brightness = current_brightness + step
                    current_brightness = math.min(100, math.max(1, current_brightness))

                    awful.spawn.with_shell(
                        string.format(
                            user_conf_apps.utils.set_brightness,
                            current_brightness
                        )
                    );
                end
            }
        )
end

function take_screenshot()
end