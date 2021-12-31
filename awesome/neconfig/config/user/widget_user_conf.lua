local widget = {
    --#region Widgets in the statusbar
    statusbar = {
        -- List of tags (virtual desktops)
        taglist = {
            -- Number the tags
            number = false,
            -- Show number of opened clients under a tag with the dots
            client_count = true
        },
        -- List of tasks (opened clients)
        tasklist = {
            -- Show the title of the task
            task_title = true,
            -- Show the properties (maximized, on top, floating, etc) of the task
            task_props = true
        },
        clock = {
            -- Format of the time written on the top or left
            primary_format = '%H:%M',
            -- Format of the time written on the bottom or right
            secondary_format = '%a %Y-%m-%d'
        }
    },
    --#endregion
    --#region Widgets in the popups
    popups = {

    }
    --#endregion
}

return widget
