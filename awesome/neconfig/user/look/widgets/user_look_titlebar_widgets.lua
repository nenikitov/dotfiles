-- Load libraries
local g_shape = require('gears').shape
-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')
local user_look_colors = require('neconfig.user.look.user_look_colors')
local scaling = require('neconfig.config.utils.utils_scaling')
local user_look_apps = require('neconfig.user.look.user_look_apps')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █▄▄ █ █ ▀█▀ ▀█▀ █▀█ █▄ █ █▀   █▀█ █▀█ █▀▀ █▀ █▀▀ ▀█▀ █▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   █▄█ █▄█  █   █  █▄█ █ ▀█ ▄█   █▀▀ █▀▄ ██▄ ▄█ ██▄  █  ▄█
local def_button_shape = g_shape.circle
local def_button_colors = {
    close    = 'red',
    maximize = 'green',
    minimize = 'yellow',
    on_top   = 'blue',
    floating = 'magenta',
    sticky   = 'cyan',
}
local def_button_inactive_color = user_look_colors.classes.surface.bg
local def_button_icon_color = user_look_colors.classes.normal.bg
local def_border_width = scaling.borders(2)
local button_presets = {
    filled_same = function(bg)
        return {
            shape = def_button_shape,
            shape_bg = bg,
            icon = bg,
            border_width = def_border_width,
            border_color = bg
        }
    end,
    filled_icon = function(bg)
        return {
            shape = def_button_shape,
            shape_bg = bg,
            icon = def_button_icon_color,
            border_width = def_border_width,
            border_color = bg
        }
    end,
    hollow_same = function(bg)
        return {
            shape = def_button_shape,
            shape_bg = '#00000000',
            icon = bg,
            border_width = def_border_width,
            border_color = bg
        }
    end,
    hollow_icon = function(bg)
        return {
            shape = def_button_shape,
            shape_bg = '#00000000',
            icon = def_button_icon_color,
            border_width = def_border_width,
            border_color = bg
        }
    end
}
local whole_button_style = function(button_name)
    local button_color = def_button_colors[button_name]
    return {
        -- When the button state is false (for example if the client not maximized for maximize button)
        inactive = {
            -- When the client is out of focus
            normal = button_presets.hollow_same(def_button_inactive_color),
            -- When the client is focused
            focus = button_presets.hollow_same(user_look_colors.palette[button_color].bg),
            -- When the button is hovered on
            hover = button_presets.hollow_icon(user_look_colors.palette[button_color].bg),
            -- When the button is pressed
            press = button_presets.hollow_icon(user_look_colors.palette[button_color].fg),
        },
        -- When the button state is true (for example if the client maximized for maximize button)
        active = {
            normal = button_presets.filled_same(def_button_inactive_color),
            focus = button_presets.filled_same(user_look_colors.palette[button_color].bg),
            hover = button_presets.filled_icon(user_look_colors.palette[button_color].bg),
            press = button_presets.filled_icon(user_look_colors.palette[button_color].fg),
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
        maximize = whole_button_style('maximize'),
        -- Button for minimizing the client
        minimize = whole_button_style('minimize'),
        -- Button for making the client display on top of other clients
        on_top = whole_button_style('on_top'),
        -- Button for toggling floating mode
        floating = whole_button_style('floating'),
        -- Button for making the client display on all tags
        sticky = whole_button_style('sticky')
    }
}

return titlebar_widget_look
