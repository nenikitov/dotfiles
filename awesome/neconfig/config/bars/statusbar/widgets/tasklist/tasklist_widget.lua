-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')

-- Get variables
local font_height = beautiful.get_font_height(beautiful.font)


--#region Helper methods

---Get the opposite direction to a direction
---@param direction string 'vertical' or 'horizontal'
---@return string direction Direction opposite to a given direction
local function get_opposite_direction(direction)
    local opposite_directions = {
        horizontal = 'vertical',
        vertical = 'horizontal'
    }
    return opposite_directions[direction]
end
--#endregion


---Construct tasklist widget
---@param args table Arguments with different settings
---@return table tasklist_widget Widget
local function get_tasklist_widget(args)
    --TODO remove this later
    args = args or {}
    -- Reference to arguments and default values
    local direction = args.direction or 'horizontal'
    local flip_decorations = args.flip_decorations or false
    local decoration_size = args.decoration_size or font_height * 0.075
    local task_spacing = args.task_spacing or 0
    local task_padding = args.task_padding or font_height * 0.1
    local contents_align = args.center_name and 'center' or 'left'
    local task_size = args.task_size or 160
    local max_size = args.max_size or 640
    -- Additional variables
    local opposite_direction = get_opposite_direction(direction)
    local side_margins = (direction == 'horizontal') and { 'left', 'right' } or { 'top', 'bottom' }
    local target_height = font_height * 1.25


    --#region Layout (direction)
    local widget_layout = {
        layout = wibox.layout.flex[direction],
        forced_width = max_size,
        spacing = task_spacing
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
        if (direction == 'horizontal')
        then
            local target_size = math.min(#objects * task_size, max_size)
            w.forced_width = target_size
        else
            local target_size = math.min(#objects * target_height, max_size)
            w.forced_height = target_size
        end
        -- Default update
        awful.widget.common.list_update(w, buttons, label, data, objects, args)
    end
    --#endregion


    --#region Template for the sub widgets
    local bar_widget = {
        widget = wibox.container.background,

        id = 'selected_bar_role',
        bg = '#0000',
        forced_width = decoration_size,
        forced_height = decoration_size
    }
    local empty_bar_widget = {
        widget = wibox.container.background,

        bg = '#0000',
        forced_width = decoration_size,
        forced_height = decoration_size
    }
    local task_name_widget = {
        widget = wibox.widget.textbox,

        id = 'text_role',
    }
    local main_widget = {
        {
            {
                awful.widget.clienticon,
                task_name_widget,

                layout = wibox.layout.fixed.horizontal,

                spacing = font_height / 8
            },

            widget = wibox.container.place,

            halign = contents_align
        },

        widget = wibox.container.margin,

        [side_margins[1]] = task_padding,
        [side_margins[2]] = task_padding
    }
    local first_widget = flip_decorations and empty_bar_widget or bar_widget
    local last_widget = flip_decorations and bar_widget or empty_bar_widget
    local widget_template = {
        {
            first_widget,
            main_widget,
            last_widget,

            layout = wibox.layout.align[opposite_direction]
        },

        widget = wibox.container.background,

        id = 'background_role',
        forced_height = target_height,

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
