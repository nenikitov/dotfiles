-- Load libraries
local gears = require('gears')
local awful = require('awful')
-- Load custom modules
local layoutbox_buttons = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_buttons')()
local widget_utils = require('neconfig.config.utils.widget_utils')


local function get_layoutbox(screen, size)
    local layoutbox = awful.widget.layoutbox(screen)
    layoutbox:buttons(layoutbox_buttons)

    return square_widget(layoutbox, size, 5)
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_layoutbox(...) end }
)
