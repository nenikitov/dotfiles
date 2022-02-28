-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')
local user_look_colors = require('neconfig.user.look.user_look_colors')
local scaling = require('neconfig.config.utils.utils_scaling')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █   █▀█ █▀█ █▄▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   █▄▄ █▄█ █▄█ █ █
local titlebar_look = {
    -- Size of the titlebar
    size = user_look_desktop.font_size * 2.25,
    margin = {
        sides = scaling.space(4),
        other = scaling.space(2)
    },

    -- Colors of the titlebar
        -- - Keys can be 'normal', 'focus', 'urgent'
        -- - 'normal' key is mandatory
    colors = {
        normal = {
            bg = 'client',
            fg = 'auto'
        },
        focus  = {
            bg = 'client',
            fg = 'auto'
        },
        urgent = {
            bg = user_look_colors.classes.error.bg,
            fg = 'auto'
        }
    }
}

return titlebar_look
