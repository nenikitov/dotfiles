-- Load libraries
local dpi = require('beautiful').xresources.apply_dpi


local interactions = {
    -- Maximum time between 2 clicks when they are considered as a double click
    double_click_time = 0.2,
    -- Values for client resizing and move with keyboard
    keyboard_client_movement = {
        -- Resizing floating clients
        resize = dpi(20),
        -- Moving floating clients
        move = dpi(20),
        -- Resizing master factor
        master = 0.01
    },
    -- Special keys that are used in binds
    keys = {
        -- Used in all the shortcuts
        super_key = 'Mod4', -- Windows key
        -- Used as "more" modifier in the shortcuts (increase, copy, etc)
        more_key  = 'Shift',
        -- Used as "less" modifier in the shortcuts (decrease, move, etc)
        less_key  = 'Control'
    },
    -- How focusing works
    focus = {
        -- Automatically give focus
        auto_focus = true,
        -- Focus clients on mouse hover
        sloppy_focus = true
    },
}

return interactions
