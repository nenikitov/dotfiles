-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful =require('beautiful')
-- Load custom modules
local layoutbox_buttons = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_buttons')()


-- Generate layout box widget
local function get_layoutbox(screen)
    local font_height = beautiful.get_font_height(beautiful.font)
    -- Construct widget
    local layoutbox = awful.widget.layoutbox {
        screen = screen
    }

    -- Layoutbox does not center itself with `halign` or `valign`, so I center it manually
    return wibox.widget {
        {
            layoutbox,

            widget = wibox.container.place,

            forced_height = font_height * 0.75,
            forced_width = font_height * 0.75

        },


        widget = wibox.container.background,

        buttons = layoutbox_buttons
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_layoutbox(...) end }
)
