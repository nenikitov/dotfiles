-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful =require('beautiful')
-- Load custom modules
local layoutbox_buttons = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_buttons')()


-- Generate layout box widget
local function get_layoutbox(screen, bar_info)
    -- Get style from the theme
    local font_size = beautiful.get_font_height(beautiful.font) * 0.75
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

    -- Construct widget
    local layoutbox = awful.widget.layoutbox {
        screen = screen,
    }

    -- Layoutbox does not center itself with `halign` or `valign`, so I center it manually
    return wibox.widget {
        widget = wibox.container.background,
        forced_height = height,
        forced_width = width,
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
