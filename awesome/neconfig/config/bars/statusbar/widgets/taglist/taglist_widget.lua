-- Load libaries
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
-- Load custom modules
local widget_utils = require('neconfig.config.utils.widget_utils')


local function get_taglist_widget(style)
    local widget_style = {
        shape = r_rect(style.corner_radius)
    }
    
    local widget_layout = {
        spacing = style.spacing,
        layout  = wibox.layout.fixed[style.direction]
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
                    left = style.padding,
                },
            },
            {
                id = 'text_margin_role',
                widget = wibox.container.margin,
                top = style.padding,
                bottom = style.padding,
                left = style.padding,
                right = style.padding,

                {
                    id = 'text_role',
                    widget = wibox.widget.textbox,
                },
            }
        },

        update_callback = function(self, t, index, tags)
            -- You can get the number of clients here
            local num_clients = #t:clients()
        end
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
