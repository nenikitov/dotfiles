-- Load libraries
local awful = require('awful')
-- Load custom modules
local taglist_buttons = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_buttons')()

-- Generate taglist widget
function get_taglist_widget(screen)
    local taglist = awful.widget.taglist {
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    return taglist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_taglist_widget(...) end }
)
