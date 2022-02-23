-- █ █ █ █ █▀▄ █▀▀ █▀▀ ▀█▀ █▀   █ █▄ █   █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▀▄▀▄▀ █ █▄▀ █▄█ ██▄  █  ▄█   █ █ ▀█   ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar_widgets = {
    -- List of tags (virtual desktops)
    tag_list = {
        -- Show the id of the tag
        number = false,
        -- Show the number of opened clients with dots
        client_count = true
    },
    -- List of tasks (opened windows)
    task_list = {
        -- Show the title of the task
        task_title = true,
        -- Show the properties of the task (maximized, minimized, floating, on top, etc)
        task_props = true
    },
    -- Current date and time
    text_clock = {
        -- Format of the primary time
        primary_format = '%H:%M',
        -- Format of the secondary time
        secondary_format = '%a %Y-%m-%d'
    }
}

return statusbar_widgets