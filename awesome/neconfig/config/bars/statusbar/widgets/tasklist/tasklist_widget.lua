-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local easing = require('rubato.easing')
local rubato = require('rubato')
local wibox = require('wibox')


local function get_tasklist_widget(style)
    --#region Precompute values
    -- Height based on font size
    local font_height = beautiful.get_font_height(beautiful.font)
    local height = font_height * 1.25
    local contents_align = style.show_task_title and 'left' or 'center'
    -- Direction of of the tasks
    local direction = (style.bar_pos == 'top' or style.bar_pos == 'bottom') and 'horizontal' or 'vertical'
    -- Margin to size the selected tag bar
    local bar_margin_pos = ({ top = 'bottom', bottom = 'top', left = 'right', right = 'left'})[style.bar_pos]
    -- TODO Smooth transitions
    --[[
    local widget_width_transition = rubato.timed {
        intro = 0,
        duration = 0.1,
        easing = easing.linear,
        rate = 120
    }
    ]]
    --#endregion


    --#region Layout (direction)
    local widget_layout = {
        layout = wibox.layout.flex[direction],
        forced_width = style.max_size,
        spacing = style.spacing / 2
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

        --#region Update tooltip
        self.tooltip_popup:set_text(c.name)
        --#endregion
    end
    local function task_created(self, c, index, clients)
        self.tooltip_popup = awful.tooltip {
            objects = { self },
            delay_show = 1,
        }
        task_updated(self, c, index, clients)
    end
    --#endregion


    --#region Callback when the whole tasklist is updated
    local function tasklist_updated(w, buttons, label, data, objects, args)
        -- Set widget size based on the number of opened clients
        if (style.bar_pos == 'top' or style.bar_pos == 'bottom')
        then
            local target_size = math.min(#objects * style.task_size, style.max_size)
            w.forced_width = target_size
        else
            local target_size = math.min(#objects * height, style.max_size)
            w.forced_height = target_size
        end
        -- Default update
        awful.widget.common.list_update(w, buttons, label, data, objects, args)
    end
    --#endregion


    --#region Template for the sub widgets
    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,
        forced_height = height,

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
                widget = wibox.container.place,
                halign = contents_align,

                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = font_height / 8,

                    {
                        widget = wibox.container.place,

                        {
                            widget = awful.widget.clienticon,
                            forced_height = font_height,
                            forced_width = font_height,
                        }
                    },
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    }
                }
            }
        },

        update_callback = task_updated,
        create_callback = task_created
    }
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
