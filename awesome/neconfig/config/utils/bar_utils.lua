-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')


-- Add, initialize and draw a section onto a custom bar
function add_section_to_bar(args)
    local sections = args.info_table.sections
    local widths = args.info_table.widths

    -- Init the section
    sections[args.name] = {
        popup = {},
        contents = {}
    }

    -- Create the popup
    sections[args.name].popup = awful.popup {
        screen = args.screen,
        placement = function(widget)
            local position = args.position.vertical .. '_' .. args.position.horizontal
            local margins = {}
            margins[args.position.vertical] = args.position.vertical_offset
            margins[args.position.horizontal] = args.position.horizontal_offset
            return awful.placement[position](
                widget,
                { margins = margins }
            )
        end,
        widget = {}
    }

    -- Populate it with widgets
    local section_layout = wibox.layout.fixed.horizontal()
    for _, widget in pairs(args.widgets)
    do
        section_layout:add(resize_vert_widget(widget, args.style.size))
    end
    local section_final_widget = {
        section_layout,
        forced_height = args.style.size,
        widget = wibox.container.background
    }

    sections[args.name].widgets = args.widgets
    
    sections[args.name].popup:setup {
        section_final_widget,

        layout = wibox.layout.fixed.horizontal
    }
end
