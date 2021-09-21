-- Load libraries
local awful = require('awful')
-- Load custom modules
local taglist_buttons = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_buttons')()


-- Generate taglist widget
local function get_taglist(screen, bar_info)
    -- Get style from the theme
    local widget_info = bar_info.widgets.taglist
    local style = {
        bar_pos = bar_info.position,
        corner_radius = bar_info.corner_radius.sections,
        size = bar_info.contents_size,
        decoration_size = widget_info.decoration_size,
        spacing = widget_info.spacing,
        max_client_count = widget_info.max_client_count
    }

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
    {  __call = function(_, ...) return get_taglist(...) end }
)
