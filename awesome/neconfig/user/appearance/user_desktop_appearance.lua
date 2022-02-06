-- Load custom modules
local s = require('')
-- TODO implement this properly
s.size = function(value)
    return value
end
s.space = function(value)
    return value
end
s.radius = function(value)
    return value
end


-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█   ▄▀█ █▀█ █▀█ █▀▀ ▄▀█ █▀█ ▄▀█ █▄ █ █▀▀ █▀▀
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀   █▀█ █▀▀ █▀▀ ██▄ █▀█ █▀▄ █▀█ █ ▀█ █▄▄ ██▄
local desktop_appearance = {
    font = 'sans-serif',
    font_size = s.size(10),

    gaps = s.space(3),

    gtk_icon_theme = 'Fluent-dark',
    try_to_force_gtk_icon_theme = true
}

return desktop_appearance
