-- Load custom modules
local statusbar_widget_list = require('neconfig.config.bars.statusbar.statusbar_widget_list')


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Show the statusbar (statusbar can still be toggled with a keyboard shortcut if hidden)
    visible = true,
    -- List of widgets and their position
    layout = {
        -- First widgets (top or left)
        front = {
            statusbar_widget_list.menu,
            statusbar_widget_list.run_menu,
            statusbar_widget_list.layout_box,
            statusbar_widget_list.tag_list
        },
        -- Middle widgets (center)
        middle = {
            statusbar_widget_list.task_list
        },
        -- Last widgets (bottom or right)
        back = {
            statusbar_widget_list.text_clock,
            statusbar_widget_list.keyboard,
            statusbar_widget_list.notification_center,
            statusbar_widget_list.system_tools
        }
    }
}

return statusbar
