-- Load libraries
local awful = require('awful')
-- Load custom modules
local tasklist_buttons = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_buttons')()


-- Generate tasklist widget
local function get_tasklist(screen, style)
    local tasklist_widget = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_widget')(style)

    local tasklist = awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = tasklist_widget.style,
        layout = tasklist_widget.layout,
        widget_template = tasklist_widget.widget_template
    }

    return tasklist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist(...) end }
)
