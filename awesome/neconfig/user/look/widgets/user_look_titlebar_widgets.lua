-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')
local user_look_colors = require('neconfig.user.look.user_look_colors')
local scaling = require('neconfig.config.utils.utils_scaling')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █   █▀█ █▀█ █▄▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   █▄▄ █▄█ █▄█ █ █
local titlebar_widget_look = {
    -- Appearance of the titlebar buttons
    buttons = {
        -- Button for closing the client
        close = {
            -- When the window is not focused
            normal = {

            },
            -- When the window is in focus
            focus = {

            },
            -- When the button is 
            hover = {

            }
        },
        -- Button for maximizing the client
        maximize = {

        },
        -- Button for minimizing the client
        minimize = {

        },
        -- Button for making the client display on top of other clients
        on_top = {

        },
        -- Button for toggling floating mode
        floating = {

        },
        -- Button for making the client display on all tags
        sticky = {

        }
    }
}

return titlebar_widget_look
