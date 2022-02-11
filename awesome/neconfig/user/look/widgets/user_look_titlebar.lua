-- Load libraries
local g_shape = require('gears').shape
-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')
local u_color_classes = require('neconfig.user.look.user_look_colors').classes
local scaling = require('neconfig.config.utils.utils_scaling')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █   █▀█ █▀█ █▄▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   █▄▄ █▄█ █▄█ █ █
local titlebar_look = {
    bar = {
        size = user_look_desktop.font_size * 1.5,
        margins = scaling.space(2),
    },

    buttons = {
        shape = g_shape.circle,

    }
}

return titlebar_look
