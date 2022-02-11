-- Load libraries
local g_table = require('gears').table
local wibox = require('wibox')
-- Load custom modules
local user_titlebar = require("neconfig.user.config.widgets.user_titlebar")
local utils_shapes = require("neconfig.config.utils.utils_shapes")
local titlebar_buttons = require("neconfig.config.widgets.titlebar.titlebar_buttons")


local function titlebar_widget_template(c)
    local direction = utils_shapes.direction_of_side(user_titlebar.position)
    local align = utils_shapes.alignments(direction)
    local init_widget = function(widget)
        return widget(c)
    end
    local buttons = titlebar_buttons(c)

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
    center_section.buttons = buttons
    local ending_section = wibox.layout.fixed[direction](
        table.unpack(
            g_table.map(
                init_widget,
                g_table.reverse(user_titlebar.layout.ending)
            )
        )
    )

    return {
        beginning_section,
        center_section,
        {
            ending_section,

            [align.direction] = align.ending,

            widget = wibox.container.place
        },

        expand = 'outside',
        buttons = buttons,

        layout = wibox.layout.align[direction]
    }
end

return titlebar_widget_template
