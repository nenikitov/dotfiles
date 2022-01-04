-- Load custom modules
local statusbar_subwidget_list = require('neconfig.config.widgets.statusbar.statusbar_subwidget_list')


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Show the statusbar (statusbar can still be toggled with a keyboard shortcut if hidden)
    visible = true,
    -- List of widgets and their position
    layout = {
        -- First widgets (top or left)
        front = {
            statusbar_subwidget_list.menu,
            statusbar_subwidget_list.run_menu,
            statusbar_subwidget_list.layout_box,
            statusbar_subwidget_list.tag_list
        },
        -- Middle widgets (center)
        middle = {
            statusbar_subwidget_list.task_list
        },
        -- Last widgets (bottom or right)
        back = {
            statusbar_subwidget_list.text_clock,
            statusbar_subwidget_list.keyboard,
            statusbar_subwidget_list.notification_center,
            statusbar_subwidget_list.system_tools
        }
    }
}

return statusbar
