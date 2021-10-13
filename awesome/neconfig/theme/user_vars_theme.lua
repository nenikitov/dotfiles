-- Load modules
local dpi = require('beautiful.xresources').apply_dpi


-- Customize this
-- █▀ █▀▀ ▄▀█ █   █ █▄ █ █▀▀
-- ▄█ █▄▄ █▀█ █▄▄ █ █ ▀█ █▄█
local scaling = {
    contents = 1.0,
    spacing = 1.0,
    rounding = 8.0
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

--- Initialize size values related to corner radius
---@param value number
---@return number
local function radius(value)
    return dpi(value) * scaling.rounding
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
        bar = radius(1),
        sections = radius(1)
    },
    -- Widgets
    widgets = {
        taglist = {
            -- Size of the selection bar and the number of clients circles
            decoration_size = size(2),
            -- Spacing between tags
            spacing = space(12),
            -- Maximum number of client circles
            max_client_count = 5
        },
        tasklist = {
            -- Size of the selection bar
            decoration_size = size(2),
            -- Spacing between tasks
            spacing = space(12),
            -- Maximum width of the task
            task_size = size(200),
            -- Maximum size of the taskbar
            max_size = 1920 - 2 * space(128) - size(600),
        },
        clock = {
            top_size = 1.0,
            top_weight = '500',
            bottom_size = 0.75,
            bottom_weight = 'normal'
        }
    }
}


-- █▀█ █▀█ █▀█ █ █ █▀█ █▀
-- █▀▀ █▄█ █▀▀ █▄█ █▀▀ ▄█
local popup = {
   background_color = '#0004',
   margin = client.gaps,
   corner_radius = radius(1)
}


local user_vars_theme = {
    general = general,
    client = client,
    statusbar = statusbar,
    popup = popup
}

return user_vars_theme
