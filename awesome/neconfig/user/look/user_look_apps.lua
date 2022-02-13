-- Load custom modules
local scaling = require('neconfig.config.utils.utils_scaling')
local colors = require('neconfig.user.look.user_look_colors')



-- ▄▀█ █▀█ █▀█ █▀   █   █▀█ █▀█ █▄▀
-- █▀█ █▀▀ █▀▀ ▄█   █▄▄ █▄█ █▄█ █ █
local apps_look = {
    -- Borders around application windows
    border = {
        -- Width of borders
        width = {
            -- Real border that changes the colors for different client status
            border    = scaling.borders(2),
            -- Subtle 3D highlight effect
            highlight = scaling.borders(1)
        },
        -- Colors of borders
            -- - Keys can be ('normal', 'active', 'floating', 'maximized', 'fullscreen', 'urgent', or a mix)
            -- - Also 'highlight'
        colors = {
            normal = colors.classes.normal.bg,
            active = colors.classes.primary.bg,
            floating_active = colors.classes.secondary.bg,
            urgent = colors.classes.error.bg,

            highlight = colors.classes.normal.fg,
        }
    },
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
            titlebar = scaling.radius(9),
            other    = scaling.radius(6)
        }
    }
}

return apps_look
