-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful =require('beautiful')
-- Load custom modules
local layoutbox_buttons = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_buttons')()


-- Generate layout box widget
local function get_layoutbox(screen, bar_info)
    -- Construct widget
    local layoutbox = awful.widget.layoutbox {
        screen = screen,
    }

    -- Layoutbox does not center itself with `halign` or `valign`, so I center it manually
    return wibox.widget {
        widget = wibox.container.background,
        forced_height = bar_info.contents_size * 0.75,
        forced_width = bar_info.contents_size * 0.75,
        buttons = layoutbox_buttons,

        {
            widget = wibox.container.place,

            layoutbox
        }
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_layoutbox(...) end }
)
