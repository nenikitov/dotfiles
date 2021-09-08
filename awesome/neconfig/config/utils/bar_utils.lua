local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')


-- Add, initialize and draw a section onto a custom bar
function add_section_to_bar(args)
    local info = args.info_table[args.name]
    local total_width = args.info_table.widths[args.position.horizontal]
    
    -- Init the section
    info = {
        popup = {},
        contents = {}
    }
    -- Init the width if not already initialized
    if not total_width
    then
        total_width = 0
    end


    -- Create the popup
    info.popup = awful.popup {
        screen = args.screen,
        placement = function(widget)
            local position = args.position.vertical .. '_' .. args.position.horizontal
            local margins = {}
            margins[args.position.vertical] = args.theme.vertical_padding
            margins[args.position.horizontal] = total_width
            return awful.placement[position](
                widget,
                { margins = margins }
            )
        end,
        widget = {}
    }

    -- Populate it with widgets
    info.widgets = args.widgets
    info.popup:setup {
        info.widgets,
        layout = wibox.layout.fixed.horizontal
    }
end
