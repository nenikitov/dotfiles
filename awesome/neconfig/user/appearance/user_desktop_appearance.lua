-- Load custom modules
local scaling = require('neconfig.config.utils.scaling_utils')


-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█   ▄▀█ █▀█ █▀█ █▀▀ ▄▀█ █▀█ ▄▀█ █▄ █ █▀▀ █▀▀
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀   █▀█ █▀▀ █▀▀ ██▄ █▀█ █▀▄ █▀█ █ ▀█ █▄▄ ██▄
local desktop_appearance = {
    font = 'sans-serif',
    font_size = scaling.size(8),

    gaps = scaling.space(3),
    borders = scaling.borders(2),

    gtk_icon_theme = 'Fluent-dark',
    try_to_force_gtk_icon_theme = true
}

return desktop_appearance
