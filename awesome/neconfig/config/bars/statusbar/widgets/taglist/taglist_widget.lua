-- Load libraries
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')


local function get_taglist_widget(style)
    --#region Precompute values
    -- Direction of of the tags
    local direction
    if (style.bar_pos == 'top' or style.bar_pos == 'bottom')
    then
        direction = 'horizontal'
    else
        direction = 'vertical'
    end
    --#endregion


    --#region Layout (direction)
    local widget_layout = {
        layout = wibox.layout.fixed[direction]
    }
    --#endregion


    --#region Callback when the taglist is updated
    local function tag_updated(self, t, index, tags)
        -- Count clients
        local clients_num = math.min(#t:clients(), style.max_client_count)

        --#region Update the color of the 'selected_bar_role'
        local selected_bar_role = self:get_children_by_id('selected_bar_role')[1]
        if (t.selected)
        then
            selected_bar_role.bg = beautiful.fg_focus
        elseif (clients_num > 0)
        then
            selected_bar_role.bg = beautiful.bg_normal
        else
            selected_bar_role.bg = '#0000'
        end
        --#endregion

        --#region Update the widget that shows the number of opened clients on a tag
        if (user_vars_conf.statusbar.widgets.taglist.show_client_count)
        then
            local client_num_role = self:get_children_by_id('client_num_role')[1]
            -- Generate circle widget
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
            -- Clear the widget with the circles
            for i = 0, 5, 1
            do
                client_num_role:remove(1)
            end
            -- Add circles to it
            for i = 1, clients_num, 1
            do
                client_num_role:add(circle)
            end
        end
        --#endregion
    end
    --#endregion
    --#region Template for the sub widgets
    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,
        forced_height = style.size,

        {
            widget = wibox.layout.stack,

            -- Selected tag decoration
            {
                widget = wibox.container.margin,
                bottom = style.size - style.decoration_size,

                {
                    widget = wibox.container.background,
                    bg = '#0000',
                    id = 'selected_bar_role',
                }
            },
            -- Main taglist widget
            {
                    widget = wibox.layout.fixed.horizontal,
                    fill_space = true,
                    spacing = style.spacing,

                    {
                        id = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                        align = 'center'
                    }
            },
            -- Number of opened clients decoration
            {
                widget = wibox.container.margin,
                top = style.size - style.decoration_size,
                left = style.size / 10,
                right = style.size / 10,

                {
                    id = 'client_num_role',
                    layout = wibox.layout.flex.horizontal,
                }
            }
        },

        update_callback = tag_updated,
        create_callback = tag_updated
    }
    --#endregion


    return {
        layout = widget_layout,
        widget_template = widget_template
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_taglist_widget(...) end }
)
