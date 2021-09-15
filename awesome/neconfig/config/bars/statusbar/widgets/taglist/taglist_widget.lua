-- Load libaries
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
-- Load custom modules
local widget_utils = require('neconfig.config.utils.widget_utils')


local function get_taglist_widget(style)
    local widget_style = {
        shape = r_rect(6)
    }
    
    local widget_layout = {
        spacing = 6,
        layout  = wibox.layout.fixed.horizontal
    }
    
    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,

        {
            widget = wibox.layout.fixed.horizontal,
            fill_space = true,

            {
                id = 'icon_margin_role',
                widget = wibox.container.margin,

                {
                    id = 'icon_role',
                    widget = wibox.widget.imagebox,
                    left = 6,
                },
            },
            {
                id = 'text_margin_role',
                widget = wibox.container.margin,
                top = 0,
                bottom = 0,
                left = 6,
                right = 6,

                {
                    id = 'text_role',
                    widget = wibox.widget.textbox,
                },
            }
        }
    }

    return {
        style = widget_style,
        layout = widget_layout,
        widget_template = widget_template
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_taglist_widget(...) end }
)
