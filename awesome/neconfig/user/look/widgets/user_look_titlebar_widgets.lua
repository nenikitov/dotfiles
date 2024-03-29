-- Load libraries
local g_shape = require('gears').shape
-- Load custom modules
local user_look_colors = require('neconfig.user.look.user_look_colors')
local scaling = require('neconfig.config.utils.utils_scaling')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █▄▄ █ █ ▀█▀ ▀█▀ █▀█ █▄ █ █▀   █▀█ █▀█ █▀▀ █▀ █▀▀ ▀█▀ █▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   █▄█ █▄█  █   █  █▄█ █ ▀█ ▄█   █▀▀ █▀▄ ██▄ ▄█ ██▄  █  ▄█
local button_shape = g_shape.circle
local button_colors = {
    close     = 'red',
    maximized = 'green',
    minimize  = 'yellow',
    ontop     = 'blue',
    floating  = 'magenta',
    sticky    = 'cyan',
}
local button_inactive_color = user_look_colors.classes.surface.bg
local button_icon_color = user_look_colors.classes.normal.bg
local button_border_width = scaling.borders(6)
local button_presets = {
    filled_same = function(bg)
        return {
            shape = button_shape,
            shape_bg = bg,
            icon = bg,
            border_width = button_border_width,
            border_color = bg
        }
    end,
    filled_icon = function(bg)
        return {
            shape = button_shape,
            shape_bg = bg,
            icon = button_icon_color,
            border_width = button_border_width,
            border_color = bg
        }
    end,
    hollow_same = function(bg)
        return {
            shape = button_shape,
            shape_bg = '#00000000',
            icon = '#00000000',
            border_width = button_border_width,
            border_color = bg
        }
    end,
    hollow_icon = function(bg)
        return {
            shape = button_shape,
            shape_bg = '#00000000',
            icon = bg,
            border_width = button_border_width,
            border_color = bg
        }
    end
}
local whole_button_style = function(button_name)
    local button_color = button_colors[button_name]
    return {
        -- When the button state is false (for example if the client not maximized for maximize button)
        inactive = {
            -- When the client is out of focus
            normal = button_presets.hollow_same(button_inactive_color),
            -- When the client is focused
            focus = button_presets.hollow_same(user_look_colors.palette.bg[button_color]),
            -- When the button is hovered on
            hover = button_presets.hollow_icon(user_look_colors.palette.bg[button_color]),
            -- When the button is pressed
            press = button_presets.hollow_icon(user_look_colors.palette.fg[button_color]),
        },
        -- When the button state is true (for example if the client maximized for maximize button)
        active = {
            normal = button_presets.filled_same(button_inactive_color),
            focus = button_presets.filled_same(user_look_colors.palette.bg[button_color]),
            hover = button_presets.filled_icon(user_look_colors.palette.bg[button_color]),
            press = button_presets.filled_icon(user_look_colors.palette.fg[button_color]),
        }
    }
end


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █ █ █ █ █▀▄ █▀▀ █▀▀ ▀█▀   █   █▀█ █▀█ █▄▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   ▀▄▀▄▀ █ █▄▀ █▄█ ██▄  █    █▄▄ █▄█ █▄█ █ █
local titlebar_widget_look = {
    -- Appearance of the titlebar buttons
    buttons = {
        -- Button for closing the client
        close = whole_button_style('close'),
        -- Button for maximizing the client
        maximized = whole_button_style('maximized'),
        -- Button for minimizing the client
        minimize = whole_button_style('minimize'),
        -- Button for making the client display on top of other clients
        ontop = whole_button_style('ontop'),
        -- Button for toggling floating mode
        floating = whole_button_style('floating'),
        -- Button for making the client display on all tags
        sticky = whole_button_style('sticky')
    }
}

return titlebar_widget_look
