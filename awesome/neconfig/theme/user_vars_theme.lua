-- Load modules
local dpi = require('beautiful.xresources').apply_dpi


-- Customize this
-- █▀▀ █▀▀ █▄ █ █▀▀ █▀█ ▄▀█ █  
-- █▄█ ██▄ █ ▀█ ██▄ █▀▄ █▀█ █▄▄
local general = {
    font = 'Jost* Regular',
    scaling = 1
}


-- Helper function to initialize size values
function size(value)
    return dpi(value) * general.scaling
end

-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    position = 'top',
    height = size(40),
    margin = {
        -- Margin between 2 ends of the bar and the corners of the screen
        corners = size(80),
        -- Margin between the bar side and the edge of the screen
        edge = size(4)
    },
    spacing = {
        widget = size(4),
        section = size(8)
    },
    corner_radius = size(12)
}


-- ▄▀█ █▀█ █▀█ █▄▄ ▄▀█ █▀█
-- █▀█ █▀▀ █▀▀ █▄█ █▀█ █▀▄
local appbar = {
    position = 'bottom',
    height = size(36),
    margin = {
        -- Margin between 2 ends of the bar and the corners of the screen
        corner = size(20),
        -- Margin between the bar side and the edge of the screen
        edge = size(6)
    },
    corner_radius = size(8)
}


local user_vars_theme = {
    general = general,
    statusbar = statusbar,
    appbar = appbar
}

return user_vars_theme
