-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')


-- Add, initialize and draw a section onto a custom bar
function add_section_to_bar(args)
    local sections = args.info_table.sections

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

function add_section(args)
    local name = args.name
    local widgets = args.widgets
    local position = args.position
    local style = args.style
    local screen = args.screen
    local info_table = args.info_table

    local position_info = generate_positon(position.side, position.section)
    local section_position = position_info.combined

    -- Init the section
    if (not info_table[section_position])
    then
        info_table[section_position] = {
            last_section = nil
        }
    end

    info_table[section_position][name] = {
        popup = {},
        contents = {}
    }


    -- Create the popup
    info_table[section_position][name].popup = awful.popup {
        screen = screen,
        placement = function(widget)
            local margins = find_margins_for_position(position_info, style, screen, info_table)

            return awful.placement[section_position](
                widget,
                { margins = margins }
            )
        end,
        widget = {}
    }

    -- Populate it with widgets
    local section_layout = wibox.layout.fixed.horizontal()
    for _, widget in pairs(widgets)
    do
        section_layout:add(resize_vert_widget(widget, style.contents_size))
    end
    local section_final_widget = {
        section_layout,
        forced_height = style.contents_size,
        widget = wibox.container.background
    }

    info_table[section_position][name].widgets = widgets
    
    info_table[section_position][name].popup:setup {
        section_final_widget,

        layout = wibox.layout.fixed.horizontal
    }

    info_table[section_position].last_section = name
end


-- Generates the position string from a side where the bar is attached and section index
-- Side is 'top', 'bottom', 'left', 'right'
-- Section is 1, 2, 3 where, in case of 'top' side, 1 is left corner, 2 is middle and 3 is right corner
function generate_positon(side, section)
    local lookup = {
        ['top'] = {
            [1] = { 'top_left', 'right' },
            [2] = { 'top', 'right' },
            [3] = { 'top_right', 'left' }
        },
        ['bottom'] = {
            [1] = { 'bottom_left', 'right' },
            [2] = { 'bottom', 'right' },
            [3] = { 'bottom_right', 'left' }
        },
        ['left'] = {
            [1] = { 'top_left', 'bottom' },
            [2] = { 'left', 'bottom' },
            [3] = { 'bottom_left', 'top' }
        },
        ['right'] = {
            [1] = { 'top_right', 'bottom' },
            [2] = { 'right', 'bottom' },
            [3] = { 'bottom_right', 'top' }
        }
    }

    return {
        combined = lookup[side][section][1],
        next_direction = lookup[side][section][2]
    }
end

-- Generate the margin table for the section position so it is after the previous one
-- This function is horrible...
function find_margins_for_position(position_info, style, screen, info_table)
    -- Lookup for the margin opposite of the direction (where previous widgets are placed)
    local lookup_opposite_margin = {
        ['top'] = 'bottom',
        ['bottom'] = 'top',
        ['left'] = 'right',
        ['right'] = 'left'
    }
    -- Lookup for the margin parallel to the direction of the widgets
    local lookup_parallel_margins = {
        ['top'] = { 'left', 'right' },
        ['bottom'] = { 'left', 'right' },
        ['left'] = { 'top', 'bottom' },
        ['right'] = { 'top', 'bottom' }
    }
    -- Lookup for the position and size measurement for the last section
    local lookup_widget_info = {
        ['top'] = { 'y', 'height' },
        ['bottom'] = { 'y', 'height' },
        ['left'] = { 'x', 'width' },
        ['right'] = { 'x', 'width' },
    }
    -- Lookup if the size of the previous widget affects the position of the next
    local lookup_margin_type = {
        ['top'] = false,
        ['bottom'] = true,
        ['left'] = true,
        ['right'] = false,
    }

    local section_position = position_info.combined
    local section_direction = position_info.next_direction

    -- Get the offset of the previous widget in this section
    local prev_section_margin
    if (not info_table[section_position].last_section)
    then
        -- 0 if it is the first widget
        prev_section_margin = 0
    else
        -- Get all needed info from previous widget
        local prev_section_name = info_table[section_position].last_section
        local prev_section_widget = info_table[section_position][prev_section_name].popup
        local widget_measurement = lookup_widget_info[section_direction]
        local position = prev_section_widget[widget_measurement[1]]
        local size = prev_section_widget[widget_measurement[2]]
        local screen_dimension = screen.geometry[widget_measurement[2]]

        -- Calculate the offset
        if (lookup_margin_type[section_direction])
        then
            -- The current section is placed after (on the right or below)
            prev_section_margin = position + size
        else
            -- The current section is placed before (on the left or above) 
            prev_section_margin = screen_dimension - position
        end
    end

    local margins
    margins[lookup_opposite_margin[section_direction]] = style.contents_parallel_padding
    margins[lookup_parallel_margins[section_direction][0]] = style.contetns_perpendicular_padding
    margins[lookup_parallel_margins[section_direction][1]] = style.contetns_perpendicular_padding
    margins[section_direction] = prev_section_margin

    return margins
end
