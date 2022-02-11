-- Load custom modules
local scaling = require('neconfig.config.utils.utils_scaling')


-- ▄▀█ █▀█ █▀█   ▄▀█ █▀█ █▀█ █▀▀ ▄▀█ █▀█ ▄▀█ █▄ █ █▀▀ █▀▀
-- █▀█ █▀▀ █▀▀   █▀█ █▀▀ █▀▀ ██▄ █▀█ █▀▄ █▀█ █ ▀█ █▄▄ ██▄
local apps_look = {
    -- Width of borders around the application windows
    borders = scaling.borders(2),
    -- Show slight lighting effect on the borders near the titlebar
    highlight_effect = true,
    -- Shape of the window
    shape = {
        -- Should the corners be rounded
            -- Can be a value (boolean) to set all corners, or a table (with keys specified below) to set individual corners
            -- - 'tl', 'tr', 'bl', 'br'
            -- - 'top', 'bottom'
            -- - 'left', 'right'
            -- - 'titlebar', 'other'
        round  = true,
        -- Radius of the corners
            -- Can be a value (number) to set all corners, or a table (with keys specified above) to set individual corners
        radius = {
            titlebar = scaling.radius(8),
            other    = scaling.radius(4)
        }
    }
}

return apps_look
