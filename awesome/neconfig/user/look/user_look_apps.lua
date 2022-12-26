-- Load custom modules
local scaling = require('neconfig.config.utils.utils_scaling')
local colors = require('neconfig.user.look.user_look_colors')



-- ▄▀█ █▀█ █▀█ █▀   █   █▀█ █▀█ █▄▀
-- █▀█ █▀▀ █▀▀ ▄█   █▄▄ █▄█ █▄█ █ █
local apps_look = {
    -- Borders around application windows
    border = {
        -- Width of borders
        width = scaling.borders(1),
        -- Colors of borders
            -- - Keys can be 'normal', 'active', 'floating', 'maximized', 'fullscreen', 'urgent', or a mix (like 'floating_active')
            -- - Also 'highlight'
            -- - 'normal' and 'active' keys are mandatory
        colors = {
            normal = colors.classes.normal.bg,
            active = colors.classes.primary.bg,
            urgent = colors.classes.error.bg,

            floating_active = colors.classes.secondary.bg,

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
            titlebar = scaling.radius(10),
            other    = scaling.radius(5)
        }
    }
}

return apps_look
