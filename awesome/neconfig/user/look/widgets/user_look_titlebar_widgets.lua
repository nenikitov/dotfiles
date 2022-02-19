-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')
local user_look_colors = require('neconfig.user.look.user_look_colors')
local scaling = require('neconfig.config.utils.utils_scaling')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █ █ █ █ █▀▄ █▀▀ █▀▀ ▀█▀   █   █▀█ █▀█ █▄▀
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   ▀▄▀▄▀ █ █▄▀ █▄█ ██▄  █    █▄▄ █▄█ █▄█ █ █
local titlebar_widget_look = {
    -- Name: titlebar_name_button_prefix_img_state

    -- name:   floating    - name of the button
    --         maximize
    --         ontop
    --         sticky
    --         close
    --         minimize

    -- prefix: normal      - window state
    -- (opt)   focus

    -- img:    active      - button state
    --         inactive

    -- state:  hover       - mouse state
    -- (opt)   press


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
