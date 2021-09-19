-- Load modules
local dpi = require('beautiful.xresources').apply_dpi


-- Customize this
-- █▀ █▀▀ ▄▀█ █   █ █▄ █ █▀▀
-- ▄█ █▄▄ █▀█ █▄▄ █ █ ▀█ █▄█
local scaling = {
    contents = 1.25,
    spacing = 3
}

--- Initialize size values related to widget scale
---@param value number
---@return number
local function size(value)
    return dpi(value) * scaling.contents
end

--- Initialize size values related to spacing
---@param value number
---@return number
local function space(value)
    return dpi(value) * scaling.spacing
end

-- █▀▀ █▀▀ █▄ █ █▀▀ █▀█ ▄▀█ █
-- █▄█ ██▄ █ ▀█ ██▄ █▀▄ █▀█ █▄▄
local general = {
    font = 'Jost* Regular',
    text_size = size(12)
}

-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █
local client = {
    gaps = space(4)
}


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Side of the screen ('top', 'bottom', 'left', or 'right')
    position = 'right',
    -- The size of the sections inside
    contents_size = size(24),
    -- Color scheme
    colors = {
        -- Main
        bg_bar = '#0004',
        bg_sections = '#0002',
    },
    -- Spacing between the bar, the screen and the sections
    margin = {
        -- Margin between 2 ends of the bar and the corners of the screen
        corners = space(32),
        -- Margin between the bar side and the edge of the screen
        edge = client.gaps,
        -- Margin between the bar and its contents
        content = client.gaps
    },
    -- Spacing between the sections and the widgets
    spacing = {
        widget = client.gaps / 2,
        section = client.gaps * 2
    },
    -- Corner rounding
    corner_radius = {
        bar = size(6),
        sections = size(6)
    }
}


local user_vars_theme = {
    general = general,
    client = client,
    statusbar = statusbar
}

return user_vars_theme
