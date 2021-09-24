-- Load libraries
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')


local function get_tasklist_widget(style)
    --#region Precompute values
    -- Height based on font size
    local height = beautiful.get_font_height(beautiful.font) * 1.5
    -- Direction of of the tasks
    local direction
    -- Margin to size the selected tag bar
    local bar_margin_pos
    if (style.bar_pos == 'top')
    then
        direction = 'horizontal'
        bar_margin_pos = 'bottom'
    elseif (style.bar_pos == 'bottom')
    then
        direction = 'horizontal'
        bar_margin_pos = 'top'
    elseif (style.bar_pos == 'right')
    then
        direction = 'vertical'
        bar_margin_pos = 'left'
    else
        direction = 'vertical'
        bar_margin_pos = 'right'
    end
    --#endregion


    --#region Layout (direction)
    local widget_layout = {
        layout = wibox.layout.flex[direction],
        forced_width = style.max_size
    }
    --#endregion


    --#region Callback when the task inside the tasklist is updated
    local function task_updated(self, c, index, clients)
        --#region Update the color of the 'selected_bar_role'
        local selected_bar_role = self:get_children_by_id('selected_bar_role')[1]
        if (c.active)
        then
            selected_bar_role.bg = beautiful.fg_focus
        elseif (not c.minimized)
        then
            selected_bar_role.bg = beautiful.fg_normal
        else
            selected_bar_role.bg = '#0000'
        end
        --#endregion
    end
    --#endregion
    --#region Template for the sub widgets
    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,
        forced_width = style.size,
        forced_height = height,

        {
            widget = wibox.container.place,
            valign = 'center',
            content_fill_horizontal = true,

            {
                widget = wibox.layout.stack,
    
                -- Selected task decoration
                {
                    widget = wibox.container.margin,
                    [bar_margin_pos] = style.size - style.decoration_size,
    
                    {
                        widget = wibox.container.background,
                        bg = '#0000',
                        id = 'selected_bar_role',
                    }
                },
                -- Main tasklist widget
                {
                    fill_space = true,
                    layout = wibox.layout.fixed.horizontal,
    
                    awful.widget.clienticon,
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    }
                }
            },
        },

        update_callback = task_updated,
        create_callback = task_updated
    }
    --#endregion


    --#region Callback when the whole tasklist is updated
    local function tasklist_updated(w, buttons, label, data, objects, args)      
        -- Set widget size based on the number of opened clients
        local target_size = math.min(#objects * style.task_size, style.max_size)
        w.forced_width = target_size

        awful.widget.common.list_update(w, buttons, label, data, objects, args)
    end
    --#endregion


    return {
        layout = widget_layout,
        widget_template = widget_template,
        update_function = tasklist_updated
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist_widget(...) end }
)
