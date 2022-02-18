-- Load libraries
local g_table = require('gears').table
local wibox = require('wibox')
-- Load custom modules
local user_titlebar = require("neconfig.user.config.widgets.user_titlebar")
local utils_shapes = require("neconfig.config.utils.utils_shapes")
local titlebar_buttons = require("neconfig.config.widgets.titlebar.titlebar_buttons")
local user_look_titlebar = require("neconfig.user.look.widgets.user_look_titlebar")


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

    -- Layouts for 3 sections
    local beginning_section = wibox.layout.fixed[direction](
        table.unpack(
            g_table.map(
                init_widget,
                user_titlebar.layout.beginning
            )
        )
    )
    local center_section = wibox.layout.fixed[direction](
        table.unpack(
            g_table.map(
                init_widget,
                user_titlebar.layout.center
            )
        )
    )
    local ending_section = wibox.layout.fixed[direction](
        table.unpack(
            g_table.map(
                init_widget,
                g_table.reverse(user_titlebar.layout.ending)
            )
        )
    )

    -- Ugly hack with spacer widget that fills the remaining space to make empty regions of titlebars intractable
    local spacer = {
        buttons = buttons,

        widget = wibox.container.background,
    }
    -- Final widget
    return {
        {
            {
                beginning_section,
                spacer,

                layout = wibox.layout.align[direction]
            },
            center_section,
            {
                spacer,
                spacer,
                ending_section,

                expand = 'inside',

                layout = wibox.layout.align[direction]
            },

            expand = 'outside',

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
