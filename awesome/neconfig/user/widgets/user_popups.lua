-- █▀█ █▀█ █▀█ █ █ █▀█ █▀
-- █▀▀ █▄█ █▀▀ █▄█ █▀▀ ▄█`
local popups = {
    -- Notifications
    notification_popup = {
        -- Time in seconds before popup disappears
        timeout = 5,
        -- Position on the screen
        position = 'top_right'
    },
    -- Popup when changing volume
    volume_popup = {
        -- Show the popup when changing volume
        show = true,
        -- Time in seconds before popup disappears
        timeout = 2,
        -- Position on the screen
        position = 'right'
    },
    -- Popup when changing brightness
    brightness_popup = {
        -- Show the popup when changing brightness
        show = true,
        -- Time in seconds before popup disappears
        timeout = 2,
        -- Position on the screen
        position = 'right'
    }
}

return popups
