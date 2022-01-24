-- Load modules
local dpi = require('beautiful.xresources').apply_dpi


-- █▀ █▀▀ ▄▀█ █   █ █▄ █ █▀▀
-- ▄█ █▄▄ █▀█ █▄▄ █ █ ▀█ █▄█
local scaling = {
    contents = 1.0,
    spacing = 1.0,
    rounding = 1.0
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
    return dpi(value) * scaling.rounding * scaling.contents
end


-- █▀▀ █▀▀ █▄ █ █▀▀ █▀█ ▄▀█ █
-- █▄█ ██▄ █ ▀█ ██▄ █▀▄ █▀█ █▄▄
local general = {
    font = 'Jost* Regular',
    text_size = size(11)
}


-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █
local client = {
    gaps = space(3),
    try_to_force_icon_theme = true,
    icon_theme = 'Fluent-dark'
}


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Side of the screen ('top', 'bottom', 'left', or 'right')
    position = 'top',
    -- The size of the sections inside
    contents_size = general.text_size * 2,
    -- Color scheme
    colors = {
        -- Main
        bg_bar = '#08080844',
        bg_sections = '#08080888',
    },
    -- Spacing between the bar and the edges of the screen
    margins = {
        -- Margin between 2 ends of the bar and the corners of the screen
        corner = space(64),
        -- Margin between the bar side and the edge of the screen
        edge = client.gaps
    },
    -- Margin between the bar and its contents
    padding = {
        corner = client.gaps * 2,
        edge = client.gaps
    },
    -- Spacing between the sections
    spacing = client.gaps * 2,
    -- Corner rounding
    corner_radius = {
        bar = radius(6),
        sections = radius(6)
    },
    -- 'False' to enable anti-aliasing. It introduces artifacts with shadows and blur of 'toolbox' widgets. 'True' to disable it. It disables anti-aliasing thus fixes the artifacts
    real_clip = {
        bar = false,
        sections = true
    },
    -- Widgets
    widgets = {
        taglist = {
            -- Size of the selection bar and the number of clients circles
            decoration_size = size(2),
            -- Padding inside a tag
            padding = space(4),
            -- Spacing between tags
            spacing = space(0),
            -- Maximum number of client circles
            max_client_count = 5
        },
        tasklist = {
            -- Size of the selection bar
            decoration_size = size(2),
            -- Padding inside a tag
            padding = space(4),
            -- Spacing between tasks
            spacing = space(0),
            -- Maximum width of the task
            task_size = size(200),
            -- Maximum size of the taskbar
            max_size = 1920 - 2 * space(64) - size(800),
        },
        clock = {
            direction = 'vertical',
            primary_size = 1.0,
            primary_weight = '500',
            secondary_size = 0.75,
            secondary_weight = 'normal'
        }
    }
}


-- █▀█ █▀█ █▀█ █ █ █▀█
-- █▀▀ █▄█ █▀▀ █▄█ █▀▀
local popup = {
    background_color = '#0008',
    offset = 3 * client.gaps,
    padding = 0,
    corner_radius = radius(12),
    popups = {
        calendar = {
            container = {
                spacing = 0,
                element_padding = general.text_size * 0.2,
            },
            date_time_header = {
                time_font_weight = '700',
                time_font_size = 2.5,
                date_font_weight = '450',
                date_font_size = 1.25,
            },
            header = {
                font_size = 1.1,
                font_weight = '500'
            },
            weekday = {
                font_weight = '500'
            },
            normal = {
                foreground_color = '#bfbfbf',
                background_color = '#0000'
            },
            focus = {
                background_color = '#fff4',
                font_weight = '700',
                corner_radius = radius(6)
            },
            weekend = {
                font_style = 'oblique'
            },
            other = {
                foreground_color = '#fff',
                background_color = '#0004',
                font_size = 1.0,
                font_weight = 'normal',
                font_style = 'normal',
                corner_radius = 0
            }
        }
    }
}


local user_vars_theme = {
    general = general,
    client = client,
    statusbar = statusbar,
    popup = popup
}

return user_vars_theme
