-- █▀█ █▀█ █▀█ █ █ █▀█ █▀
-- █▀▀ █▄█ █▀▀ █▄█ █▀▀ ▄█`
local popups = {
    -- Notifications
    notification= {
        -- Time in seconds before popup disappears
        timeout = 5,
        -- Position on the screen
        position = 'top_right'
    },
    -- Popup when changing volume
    volume = {
        -- Show the popup when changing volume
        show = true,
        -- Time in seconds before popup disappears
        timeout = 2,
        -- Position on the screen
        position = 'right'
    },
    -- Popup when changing brightness
    brightness = {
        -- Show the popup when changing brightness
        show = true,
        -- Time in seconds before popup disappears
        timeout = 2,
        -- Position on the screen
        position = 'right'
    }
}

return popups
