-- Load libraries
local awful = require('awful')
-- Load custom modules
local tasklist_buttons = require('neconfig.config.widgets.statusbar.subwidgets.tasklist.tasklist_buttons')


-- Generate tasklist widget
local function get_tasklist(screen, args)
    -- Get custom widget properties
    local tasklist_widget = require('neconfig.config.widgets.statusbar.subwidgets.tasklist.tasklist_widget')(args)

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

return get_tasklist
