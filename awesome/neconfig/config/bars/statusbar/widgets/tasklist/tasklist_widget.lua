-- Load libraries
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')


local function get_tasklist_widget(style, screen, tasklist_getter_func)
    --#region Callback when the tasklist is updated
    local function task_updated(self, c, index, clients)
        -- This is called when a sub widget is updated
        -- I need to find a function that calls when the tasklist is updated
        -- ? args.update_function and awful.widget.common.list_update
        local naughty = require('naughty')

        if (#clients == 0)
        then
            naughty.notify {
                text = 'No clients'
            }
        end

        for i, cl in ipairs(clients) do
            naughty.notify {
                text = tostring(i .. ' - ' .. cl.name),
                screen = screen,
            }
        end


        -- TODO
        --#region Update total widget size
        --[[
        -- Get the parent widget through that ugly hack
        local parent = tasklist_getter_func()
        -- Update the size
        if (#clients == 0)
        then
            parent.forced_width = 0
        elseif (#clients <= style.size_adapt_client_count)
        then
            parent.forced_width = style.max_size / style.size_adapt_client_count * #clients
        end
        ]]
        --#endregion

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




    local widget_style = nil


    local widget_layout = {
        layout = wibox.layout.flex.horizontal,
        forced_width = style.max_size
    }


    local widget_template = {
        id = 'background_role',
        widget = wibox.container.background,
        forced_height = style.size,

        {
            widget = wibox.layout.stack,

            -- Selected task decoration
            {
                widget = wibox.container.margin,
                bottom = style.size - style.decoration_size,

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

        update_callback = task_updated,
        create_callback = task_updated
    }

    return {
        style = widget_style,
        layout = widget_layout,
        widget_template = widget_template
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist_widget(...) end }
)
