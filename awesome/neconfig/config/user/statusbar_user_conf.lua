-- Load custom modules
local statusbar_widget_list = require('neconfig.config.bars.statusbar.statusbar_widget_list')


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Show the status bar by default (statusbar can be toggled with a keyboard shortcut)
    visible = true,
    --[[
    widget_layout = {
        front = {
            statusbar_widget_list.menu,
            statusbar_widget_list.run_menu,
            statusbar_widget_list.layout_box,
            statusbar_widget_list.tag_list
        },
        middle = {
            statusbar_widget_list.task_list
        },
        back = {
            statusbar_widget_list.text_clock,
            statusbar_widget_list.keyboard,
            statusbar_widget_list.notification_center,
            statusbar_widget_list.system_tools
        }
    },
    widget_settings = {
        taglist = {
            -- Should tags be numbered
            number = false,
            -- Should the client count indicator (small dots under the tag) be shown
            show_client_count = true
        },
        -- List of opened clients
        tasklist = {
            -- Should the name of the task be shown
            show_task_title = true,
            -- Should the property (maximized, on top, etc) be shown
            show_task_props = true
        },
        -- Analog clock
        clock = {
            -- Format of the time written on the top or left
            primary_format = '%H:%M',
            -- Format of the time written on the bottom or right
            secondary_format = '%a %Y-%m-%d',
        },
        -- System tools
        sys_tools = {
            -- Should be shown
            visible = true,
            -- Name of the thermal zone corresponding to CPU
            cpu_thermal_zone = 'thermal_zone1', -- Thermal zone 2 PC
            -- Name of the sound card
            sound_card = 'sofhdadsp'
        }
    },
    ]]
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
            -- Name of the thermal zone corresponding to CPU
            cpu_thermal_zone = 'thermal_zone1', -- Thermal zone 2 PC
            -- Name of the sound card
            sound_card = 'sofhdadsp'
        }
    }
}

return statusbar
