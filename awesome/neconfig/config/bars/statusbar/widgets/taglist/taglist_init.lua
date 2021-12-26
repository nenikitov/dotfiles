-- Load libraries
local awful = require('awful')
-- Load custom modules
local taglist_buttons = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_buttons')


-- Construct taglist widget
local function get_taglist(screen, bar_info, args)
    -- Get style from the theme
    local widget_info = bar_info.widgets.taglist
    -- Get custom widget properties
    local taglist_widget = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_widget')(args)

    -- Construct widget
    local taglist = awful.widget.taglist {
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout = taglist_widget.layout,
        widget_template = taglist_widget.widget_template
    }

    -- Hack to prematurely update taglist on creation, so the widgets placed after it get the correct width and height
    taglist._do_taglist_update_now()

    return taglist
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_taglist(...) end }
)
