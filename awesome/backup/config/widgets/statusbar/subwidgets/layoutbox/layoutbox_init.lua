-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful =require('beautiful')
-- Load custom modules
local layoutbox_buttons = require('neconfig.config.widgets.statusbar.subwidgets.layoutbox.layoutbox_buttons')

-- Get variables
local font_height = beautiful.get_font_height(beautiful.font)


-- Generate layout box widget
local function get_layoutbox(screen)
    -- Construct widget
    local layoutbox = awful.widget.layoutbox {
        screen = screen
    }

    -- Layoutbox does not center itself with `halign` or `valign`, so I center it manually
    return wibox.widget {
        layoutbox,

        widget = wibox.container.place,

        forced_height = font_height * 0.75,
        forced_width = font_height * 0.75,

        buttons = layoutbox_buttons
    }
end

return get_layoutbox
