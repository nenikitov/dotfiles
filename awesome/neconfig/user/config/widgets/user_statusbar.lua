-- Load custom modules
local statusbar_subwidget_list = require('neconfig.config.widgets.statusbar.statusbar_subwidget_list')


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀   █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█   █▄█ █▀█ █▀▄
-- Status bars on the primary screen
local primary = {
    -- Bar on top of the screen
    top = {
        -- Visible by default (if hidden can still be toggled with the shortcut)
        visible = true,
        -- Is drawn on top of the clients
        on_top = false,
        -- Sub widgets
        layout = {
            -- Start of the bar (left)
            beginning = {
                statusbar_subwidget_list.menu,
                statusbar_subwidget_list.run_menu,
                statusbar_subwidget_list.layout_box,
                statusbar_subwidget_list.tag_list
            },
            -- Center of the bar (middle)
            center = {
                statusbar_subwidget_list.task_list
            },
            -- End of the bar (right)
            ending = {
                statusbar_subwidget_list.text_clock,
                statusbar_subwidget_list.keyboard,
                statusbar_subwidget_list.notification_center,
                statusbar_subwidget_list.system_tools
            }
        }
    }
}
-- Status bars on the other screens
local others = primary

return {
    primary = primary,
    others = others
}
