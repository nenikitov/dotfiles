-- Load modules
local dpi = require('beautiful.xresources').apply_dpi


-- Customize this
-- █▀ █▀▀ ▄▀█ █   █ █▄ █ █▀▀
-- ▄█ █▄▄ █▀█ █▄▄ █ █ ▀█ █▄█
local scaling = {
    contents = 1.25,
    spacing = 1.0
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
    position = 'top',
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
        corners = space(128),
        -- Margin between the bar side and the edge of the screen
        edge = client.gaps,
        -- Margin between the bar and its contents
        content = client.gaps
    },
    -- Spacing between the sections
    spacing = client.gaps * 2,
    -- Corner rounding
    corner_radius = {
        bar = size(6),
        sections = size(6)
    },
    -- Widgets
    widgets = {
        taglist = {
            decoration_size = size(2),
            spacing = space(12),
            max_client_count = 5
        },
        tasklist = {
            decoration_size = size(2),
            spacing = space(12),
            task_size = size(250),
            max_size = size(500)--1920 - 2 * space(128) - size(600),
        }
    }
}


local user_vars_theme = {
    general = general,
    client = client,
    statusbar = statusbar
}

return user_vars_theme
