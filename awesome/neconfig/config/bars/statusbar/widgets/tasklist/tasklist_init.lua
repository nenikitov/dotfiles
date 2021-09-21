-- Load libraries
local awful = require('awful')
-- Load custom modules
local tasklist_buttons = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_buttons')()


-- Generate tasklist widget
local function get_tasklist(screen, bar_info, widget)
    -- Get style from the theme
    local widget_info = bar_info.widgets.tasklist
    local style = {
        bar_pos = bar_info.position,
        corner_radius = bar_info.corner_radius.sections,
        size = bar_info.contents_size,
        decoration_size = widget_info.decoration_size,
        spacing = widget_info.spacing,
        size_adapt_client_count = widget_info.size_adapt_client_count,
        max_size = widget_info.max_size
    }

    -- Ugly hack to pass the tasklist widget to the sub widgets
    -- Hopefully the callback of the sub widget will not execute before the tasklist inits
    -- I really hope there is a better solution for this, but its the best I can do
    -- I am surprised it works...
    local tasklist_ref
    local function get_tasklist_before_init()
        return tasklist_ref
    end

    local tasklist_widget = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_widget')(style, get_tasklist_before_init)

    local tasklist = awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = tasklist_widget.style,
        layout = tasklist_widget.layout,
        widget_template = tasklist_widget.widget_template
    }
    tasklist_ref = tasklist

    return tasklist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist(...) end }
)
