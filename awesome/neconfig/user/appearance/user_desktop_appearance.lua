-- Load custom modules
local scaling = require('neconfig.config.utils.utils_scaling')


-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█   ▄▀█ █▀█ █▀█ █▀▀ ▄▀█ █▀█ ▄▀█ █▄ █ █▀▀ █▀▀
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀   █▀█ █▀▀ █▀▀ ██▄ █▀█ █▀▄ █▀█ █ ▀█ █▄▄ ██▄
local desktop_appearance = {
    font = 'sans-serif',
    font_size = scaling.size(8),

    gaps = scaling.space(3),

    gtk_icon_theme = 'Fluent-dark',
    try_to_force_gtk_icon_theme = true
}

return desktop_appearance
