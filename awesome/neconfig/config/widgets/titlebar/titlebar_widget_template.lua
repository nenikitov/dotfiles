-- Load libraries
local g_table = require('gears').table
local wibox = require('wibox')
-- Load custom modules
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local utils_shapes = require('neconfig.config.utils.utils_shapes')
local titlebar_buttons = require('neconfig.config.widgets.titlebar.titlebar_buttons')
local user_look_titlebar = require('neconfig.user.look.widgets.user_look_titlebar')
local titlebar_subwidget_list = require('neconfig.config.widgets.titlebar.titlebar_subwidget_list')


--#region Helper functions
local function is_resizable(c)
    local h = c.size_hints

    if h.max_width and h.min_width and h.max_height and h.min_height then
        return not (h.max_width == h.min_width and h.max_height == h.min_height)
    end

    return true
end
local function is_tileable(c)
    return not(c.floating and not is_resizable(c))
end
--#endregion


local function titlebar_widget_template(c)
    local direction = utils_shapes.direction_of_side(user_titlebar.position)
    local margin_side1, margin_side2 = utils_shapes.sides_along_direction(direction)
    local margin_other1, margin_other2 = utils_shapes.sides_along_direction(utils_shapes.perp_direction(direction))
    local buttons = titlebar_buttons(c)
    -- Function to init a widget inside a titlebar
    local function init_widget(prototype)
        if type(prototype) == 'function' then
            -- Pass client to the widget
            local widget = prototype(c)
            -- Provide default buttons if has no buttons
            if #widget:buttons() == 0 then
                widget:buttons(buttons)
            end
            return widget
        else
            return prototype
        end
    end
    -- Remove unusable widgets (such as maximize button for the client that cannot resize)
    local function remove_unusable_buttons(widgets)
        local new_widgets = {}

        for _, w in ipairs(widgets) do
            if w == titlebar_subwidget_list.maximize then
                if is_resizable(c) then
                    table.insert(new_widgets, w)
                end
            elseif w == titlebar_subwidget_list.floating then
                if is_tileable(c) then
                    table.insert(new_widgets, w)
                end
            else
                table.insert(new_widgets, w)
            end
        end

        return new_widgets
    end
    -- Initialize a section with buttons and remove unusable buttons
    local function prepare_section(section)
        return wibox.layout.fixed[direction](
            table.unpack(
                g_table.map(
                    init_widget,
                    remove_unusable_buttons(section)
                )
            )
        )
    end

    -- Layouts for 3 sections
    local beginning_section = prepare_section(user_titlebar.layout.beginning)
    local center_section = prepare_section(user_titlebar.layout.center)
    local ending_section = prepare_section(user_titlebar.layout.ending)

    -- Ugly hack with spacer widget that fills the remaining space to make empty regions of titlebars interactive
    local spacer = {
        buttons = buttons,

        widget = wibox.container.background,
    }

    -- Final widget
    return {
        {
            {
                -- Ensure beginning section alignment and pad with interactive spacer
                beginning_section,
                spacer,

                layout = wibox.layout.align[direction]
            },
            {
                -- Ensure center section alignment and pad with interactive spacer
                spacer,
                center_section,
                spacer,

                expand = wibox.layout.align.expand_modes.OUTSIDE,

                layout = wibox.layout.align[direction]
            },
            {
                -- Ensure ending section alignment and pad with interactive spacer
                nil,
                spacer,
                ending_section,

                layout = wibox.layout.align[direction]
            },

            expand = wibox.layout.align.expand_modes.JUSTIFIED,

            layout = wibox.layout.align[direction]
        },

        [margin_side1] = user_look_titlebar.margin.sides,
        [margin_side2] = user_look_titlebar.margin.sides,
        [margin_other1] = user_look_titlebar.margin.other,
        [margin_other2] = user_look_titlebar.margin.other,

        widget = wibox.container.margin
    }
end

return titlebar_widget_template
