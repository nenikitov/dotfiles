-- Load libraries
local awful = require('awful')
local beautiful =require('beautiful')
-- Load custom modules
local layoutbox_buttons = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_buttons')()


local function get_layoutbox(screen, bar_info)
    -- Get style from the theme
    local font_size = beautiful.get_font_height(beautiful.font)
    local width
    local height
    if (bar_info.position == 'top' or bar_info.position == 'bottom')
    then
        width = font_size
        height = bar_info.contents_size
    else
        height = font_size
        width = bar_info.contents_size
    end

    local layoutbox = awful.widget.layoutbox(screen)


    layoutbox.buttons = layoutbox_buttons
    layoutbox.forced_width = width
    layoutbox.forced_height = height
    layoutbox.fill_space = true

    return layoutbox
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_layoutbox(...) end }
)
