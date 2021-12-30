-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
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


---Construct taglist widget
---@param args table Arguments with different settings
---@return table taglist_widget Widget
local function get_taglist_widget(args)
    -- Reference to arguments and default values
    local direction = args.direction or 'horizontal'
    local flip_decorations = args.flip_decorations or false
    local decoration_size = args.decoration_size or font_height * 0.075
    local show_client_count
    if args.show_client_count == nil then
        show_client_count = true
    else
        show_client_count = args.show_client_count
    end
    local tag_spacing = args.tag_spacing or 0
    local tag_padding = args.tag_padding or font_height * 0.1
    local max_client_count = args.max_client_count or 5
    -- Additional variables
    local opposite_direction = get_opposite_direction(direction)
    local side_margins = (direction == 'horizontal') and { 'left', 'right' } or { 'top', 'bottom' }


    --#region Layout (direction)
    local widget_layout = {
        layout = wibox.layout.fixed[direction],
        spacing = tag_spacing
    }
    --#endregion


    --#region Callback when the taglist is updated
    local function tag_updated(self, t, index, tags)
        -- Count clients
        local clients_num = #t:clients()
        local dots_num = math.min(clients_num, max_client_count)

        --#region Update the color of the 'selected_bar_role'
        local selected_bar_role = self:get_children_by_id('selected_bar_role')[1]
        if (t.selected) then
            selected_bar_role.bg = beautiful.fg_focus
        elseif (clients_num > 0) then
            selected_bar_role.bg = beautiful.fg_normal
        else
            selected_bar_role.bg = '#0000'
        end
        --#endregion

        --#region Update the widget that shows the number of opened clients on a tag
        if (show_client_count) then
            local client_num_role = self:get_children_by_id('client_num_role')[1]
            -- Generate circle widget
            local circle_bg
            if (t.selected) then
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
            for i = 0, max_client_count, 1
            do
                client_num_role:remove(1)
            end
            -- Readd circles to it
            for i = 1, dots_num, 1
            do
                client_num_role:add(circle)
            end
        end
        --#endregion

        --#region Update tooltip
        self.tooltip_popup:set_text('[ #' .. index .. '. ' .. t.name .. ' ] — ' .. clients_num .. ' open')
        --#endregion
    end
    local function tag_created(self, t, index, tags)
        self.tooltip_popup = awful.tooltip {
            objects = { self },
            delay_show = 1
        }
        tag_updated(self, t, index, tags)
    end
    --#endregion


    --#region Template for the sub widgets
    local bar_widget = {
        widget = wibox.container.background,

        id = 'selected_bar_role',
        bg = '#0000',
        forced_height = decoration_size,
        forced_width = decoration_size
    }
    local circles_widget = {
        layout = wibox.layout.flex[direction],

        id = 'client_num_role',
        forced_width = decoration_size,
        forced_height = decoration_size
    }
    local main_widget = {
        {
            {
                id = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            {
                id = 'text_role',
                widget = wibox.widget.textbox,
                align = 'center'
            },

            widget = wibox.layout.fixed.horizontal,

            fill_space = true,
        },

        widget = wibox.container.margin,

        [side_margins[1]] = tag_padding,
        [side_margins[2]] = tag_padding
    }
    local first_widget = flip_decorations and circles_widget or bar_widget
    local last_widget = flip_decorations and bar_widget or circles_widget
    local widget_template = {
        {
            first_widget,
            main_widget,
            last_widget,

            layout = wibox.layout.align[opposite_direction],
        },

        widget = wibox.container.background,

        id = 'background_role',
        forced_height = font_height * 1.25,

        update_callback = tag_updated,
        create_callback = tag_created
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
