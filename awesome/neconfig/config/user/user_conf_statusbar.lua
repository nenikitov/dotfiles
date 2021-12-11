-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Show the status bar by default (statusbar can be toggled with a keyboard shortcut)
    visible = true,
    -- Widget settings
    widgets = {
        -- Menu widget
        menu = {
            -- Should be shown
            visible = true
        },
        -- Run menu widget
        run_menu = {
            -- Should be shown
            visible = false
        },
        -- Current desktop layout
        layoutbox = {
            -- Should be shown
            visible = true
        },
        -- List of tags (virtual desktops)
        taglist = {
            visible = true,
            -- Should tags be numbered
            number = false,
            -- Should the client count indicator (small dots under the tag) be shown
            show_client_count = true
        },
        -- List of opened clients
        tasklist = {
            -- Should be shown
            visible = true,
            -- Should the name of the task be shown
            show_task_title = true,
            -- Should the property (maximized, on top, etc) be shown
            show_task_props = true
        },
        -- Analog clock
        clock = {
            -- Should be shown
            visible = true,
            -- Format of the time written on the top or left
            primary_format = '%H:%M',
            -- Format of the time written on the bottom or right
            secondary_format = '%a %Y-%m-%d',
        },
        -- Current keyboard layout
        keyboard_layout = {
            -- Should be shown
            visible = false,
        },
        -- Notifications pane
        notifications_pane = {
            -- Should be shown
            visible = true
        },
        -- System tools
        sys_tools = {
            -- Should be shown
            visible = true,
            -- Name of the thermal 
            cpu_thermal_zone='thermal_zone2' -- Thermal zone 2 PC
        }
    }
}

return statusbar
