-- Load libraries
local awful = require('awful')
-- Load custom modules
local tasklist_buttons = require('config.bars.statusbar.widgets.tasklist.tasklist_buttons')()

-- Generate tasklist widget
function get_tasklist_widget(screen)
    local tasklist = awful.widget.tasklist {
        screen = screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    }

    return tasklist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist_widget(...) end }
)