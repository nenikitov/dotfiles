-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
-- Load custom modules
local statusbar_user_conf = require('neconfig.config.user.statusbar_user_conf')


local function get_taglist_widget(style)
    --#region Precompute values
    -- Direction of of the tags
    local direction = (style.bar_pos == 'top' or style.bar_pos == 'bottom') and 'horizontal' or 'vertical'
    -- Margin to size the selected tag bar
    local bar_margin_pos = ({ top = 'bottom', bottom = 'top', left = 'right', right = 'left'})[style.bar_pos]
    -- Margin to size the opened clients circles
    local dots_margin_pos = style.bar_pos
    -- Other margins to reduce opened clients distance
    local dots_margin_others = (style.bar_pos == 'top' or style.bar_pos == 'bottom') and { 'right', 'left' } or { 'top', 'bottom' }
    --#endregion


    --#region Layout (direction)
    local widget_layout = {
        layout = wibox.layout.fixed[direction],
        spacing = style.spacing / 2
    }
    --#endregion


    --#region Callback when the taglist is updated
    local function tag_updated(self, t, index, tags)
        -- Count clients
        local clients_num = #t:clients()
        local dots_num = math.min(clients_num, style.max_client_count)

        --#region Update the color of the 'selected_bar_role'
        local selected_bar_role = self:get_children_by_id('selected_bar_role')[1]
        if (t.selected)
        then
            selected_bar_role.bg = beautiful.fg_focus
        elseif (clients_num > 0)
        then
            selected_bar_role.bg = beautiful.fg_normal
        else
            selected_bar_role.bg = '#0000'
        end
        --#endregion

        --#region Update the widget that shows the number of opened clients on a tag
        if (statusbar_user_conf.widgets.taglist.show_client_count)
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
            for i = 0, style.max_client_count, 1
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
        self.tooltip_popup:set_text('[ #' .. index .. '. ' .. t.name .. ' ] -- ' .. clients_num .. ' open')
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
    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,
        forced_height = beautiful.get_font_height(beautiful.font) * 1.25,

        {
            widget = wibox.layout.stack,

            -- Selected tag decoration
            {
                widget = wibox.container.margin,
                [bar_margin_pos] = style.size - style.decoration_size,

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
                spacing = style.spacing / 2,

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
                [dots_margin_pos] = style.size - style.decoration_size,
                [dots_margin_others[1]] = 5,
                [dots_margin_others[2]] = 5,

                {
                    id = 'client_num_role',
                    layout = wibox.layout.flex[direction],
                }
            }
        },

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
