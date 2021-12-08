-- Load libraries
local awful = require('awful')
-- Load custom modules
local tasklist_buttons = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_buttons')()
local user_conf_statusbar = require('neconfig.config.user.user_conf_statusbar')


-- Generate tasklist widget
local function get_tasklist(screen, bar_info)
    -- Get style from the theme
    local widget_info = bar_info.widgets.tasklist
    local style = {
        bar_pos = bar_info.position,
        corner_radius = bar_info.corner_radius.sections,
        size = bar_info.contents_size,
        decoration_size = widget_info.decoration_size,
        spacing = widget_info.spacing,
        task_size = widget_info.task_size,
        max_size = widget_info.max_size,
        show_task_title = user_conf_statusbar.widgets.tasklist.show_task_title
    }

    -- Get custom widget properties
    local tasklist_widget = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_widget')(style)

    -- Construct widget
    local tasklist = awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = tasklist_widget.layout,
        widget_template = tasklist_widget.widget_template,
        update_function = tasklist_widget.update_function
    }

    -- Hack to prematurely update tasklist on creation, so the widgets placed after it get the correct width and height
    tasklist._do_tasklist_update_now()

    return tasklist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist(...) end }
)
