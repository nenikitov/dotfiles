-- Load libraries
local awful = require('awful')
-- Load custom modules
local taglist_buttons = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_buttons')()


-- Generate taglist widget
local function get_taglist_widget(screen, style)
    local taglist_widget = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_widget')(style)

    local taglist = awful.widget.taglist {
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = taglist_widget.style,
        layout = taglist_widget.layout,
        widget_template = taglist_widget.widget_template
    }

    return taglist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_taglist_widget(...) end }
)
