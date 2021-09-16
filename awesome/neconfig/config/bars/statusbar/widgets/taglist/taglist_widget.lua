-- Load libaries
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
-- Load custom modules
local widget_utils = require('neconfig.config.utils.widget_utils')


local function get_taglist_widget(style)  
    local widget_style = nil
    --[[
    {
        shape = r_rect(style.corner_radius)
    }
    ]]
    
    local widget_layout = {
        spacing = style.spacing,
        layout = wibox.layout.fixed[style.direction]
    }


    local tag_updated = function (self, t, index, tags)
        --#region Update the color of the 'selected_bar_role'
        local selected_bar_role = self:get_children_by_id('selected_bar_role')[1]
        if (t.selected)
        then
            selected_bar_role.bg = beautiful.fg_focus
        else
            selected_bar_role.bg = '#0000'
        end
        --#endregion

        --#region Update the widget that shows the number of opened clients on a tag
        -- Count clients
        local clients_num = math.min(#t:clients(), 5)
        local client_num_role = self:get_children_by_id('client_num_role')[1]
        local circle_bg
        if (t.selected)
        then
            circle_bg = beautiful.fg_focus
        else
            circle_bg = beautiful.fg_normal
        end
        local circle = wibox.widget {
            bg = circle_bg,
            shape = gears.shape.circle,
            widget = wibox.container.background,
        }
        -- Clear the widget
        for i = 0, 5, 1
        do
            client_num_role:remove(1)
        end
        -- Add circles
        for i = 1, clients_num, 1
        do
            client_num_role:add(circle)
        end
        --#endregion
    end

    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,

        {
            widget = wibox.layout.stack,

            -- Selected tag Bar
            {
                widget = wibox.container.margin,
                bottom = style.size - style.decoration_size,

                {
                    widget = wibox.container.background,
                    bg = '#0000',
                    id = 'selected_bar_role'
                }
            },
            -- Main taglist widget
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
            -- Number of opened clients
            {
                widget = wibox.container.margin,
                top = style.size - style.decoration_size,
                left = style.size / 6,
                right = style.size / 6,

                {
                    id = 'client_num_role',
                    layout = wibox.layout.flex.horizontal,
                }
            }
        },


        update_callback = tag_updated,
        create_callback = tag_updated
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
