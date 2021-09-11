-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')


--- Add, initialize and draw a section
---@param args table Name, widget list, position, style, screen and info_table
function add_section(args)
    --#region Aliases for the arguments
    local name = args.name
    local widgets = args.widgets
    local position = args.position
    local style = args.style
    local screen = args.screen
    local info_table = args.info_table
    -- Precalculate position info
    local position_info = generate_positon_info(position.side, position.section)
    local section_position = position_info.combined
    --#endregion

    --#region Init
    -- Init the section if it is the first widget to be placed here
    if (not info_table[section_position])
    then
        info_table[section_position] = {
            last_section = nil
        }
    end
    -- Get last section before creating the section's widgets
    -- So every section stays in the correct order
    local last_section = info_table[section_position].last_section

    -- Init current section
    info_table[section_position][name] = {
        popup = {},
        contents = {}
    }
    --#endregion


    --#region Create the popup
    info_table[section_position][name].popup = awful.popup {
        screen = screen,
        placement = function(wi)
            local margins = find_margins_for_position(position, last_section, style, screen, info_table)
            return awful.placement[section_position](wi, { margins = margins })
        end,
        widget = {},
        bg = '#a00'
    }
    --#endregion

    --#region Populate the section with each widget in the list
    info_table[section_position][name].widgets = widgets
    -- Get if the section should restrict the widgets width or height
    local size_param
    if (position_info.next_direction == 'top' or position_info.next_direction == 'bottom')
    then
        size_param = 'width'
    else
        size_param = 'height'
    end

    -- Create a layout
    local section_layout = wibox.layout.fixed.horizontal()

    -- Add widgets to it
    for _, widget in pairs(info_table[section_position][name].widgets)
    do
        section_layout:add(resize_vert_widget(widget, style.contents_size))
    end

    -- Construct final widget
    local section_final_widget = {
        section_layout,
        ['forced_' .. size_param] = style.contents_size,
        widget = wibox.container.background
    }

    -- Put it in the popup
    info_table[section_position][name].popup:setup {
        section_final_widget,

        layout = wibox.layout.fixed.horizontal
    }
    --#endregion


    -- Update last_popup so the next popup places after this one
    info_table[section_position].last_section = name
end


--- Generates the position string from a side where the bar is attached and section index
---@param side string 'top', 'bottom', 'left', 'right'
---@param section number 1, 2, 3 where, in case of 'top' side, 1 is left corner, 2 is middle and 3 is right corner
---@return table position_info Where the widget should be located and what is the direction to the next widget
function generate_positon_info(side, section)
    -- 1st value is the combined position of the popup
    -- 2nd is where the next section would be if placed in the same screen corner
    local lookup = {
        ['top'] = {
            [1] = { 'top_left',     'right' },
            [2] = { 'top',          'right' },
            [3] = { 'top_right',    'left'  }
        },
        ['bottom'] = {
            [1] = { 'bottom_left',  'right' },
            [2] = { 'bottom',       'right' },
            [3] = { 'bottom_right', 'left'  }
        },
        ['left'] = {
            [1] = { 'top_left',     'bottom' },
            [2] = { 'left',         'bottom' },
            [3] = { 'bottom_left',  'top'    }
        },
        ['right'] = {
            [1] = { 'top_right',    'bottom' },
            [2] = { 'right',        'bottom' },
            [3] = { 'bottom_right', 'top'    }
        }
    }

    return {
        combined = lookup[side][section][1],
        next_direction = lookup[side][section][2]
    }
end


--- Generate the margin table for the section position so it is after the previous one
---@param position table Position of the bar and section index
---@param last_section string The name of the previous section popup
---@param style table List of margins and spacing info
---@param screen table Screen where to put the popup
---@param info_table table Table from where to read and where to store all the data
---@return table margins Final margins
function find_margins_for_position(position, last_section, style, screen, info_table)
    -- Precalculate all values
    local position_info = generate_positon_info(position.side, position.section)

    local dir = position_info.next_direction
    local pos = position_info.combined

    local edge_dir = position.side

    -- Calculate the margin to the edge of the screen where the section (and the bar) are attached
    local margins_to_edge = style.margin.edge + style.margin.content


    -- Margin to the corners where the section is attached
    local margin_to_corner
    if (position.section == 2)
    then
        -- If the section is in the middle, just put it in the center without any content offset
        return {
            [edge_dir] = margins_to_edge
        }
    else
        -- Calculate the margin to the corner where the section is attached
        -- Find its location
        local lookup_margin_before = {
            ['top']    = 'bottom',
            ['bottom'] = 'top',
            ['left']   = 'right',
            ['right']  = 'left'
        }
        local corner_dir = lookup_margin_before[dir]
        -- Calculate the offset of this margin (depends on the section that was placed before)
        local margin_content_offset = 0
        -- Check last placed section
        if (not last_section)
        then
            -- There was no sections placed in this corner, this is the first one
            -- So the margin depends on the bar
            margin_content_offset = style.margin.corners
        else
            -- It is not a first section
            -- So offset the current section so it does not overlap with previous
            -- Find info parameters to calculate content offset
            local size_param
            local pos_param
            if (dir == 'top' or dir == 'bottom')
            then
                size_param = 'height'
                pos_param = 'y'
            else
                size_param = 'width'
                pos_param = 'x'
            end
            -- Get info
            local section_size = info_table[pos][last_section].popup[size_param]
            local section_position = info_table[pos][last_section].popup[pos_param]
            local screen_size = screen.geometry[size_param]
            local screen_position = screen.geometry[pos_param]

            -- Calculate the offset
            if (dir == 'bottom' or dir == 'right')
            then
                -- The current section is placed after (on the right or below)
                margin_content_offset = section_position + section_size - screen_position
            else
                -- The current section is placed before (on the left or above) 
                margin_content_offset = screen_size - section_position + screen_position
            end
        end
        -- Add spacing between last and current section
        margin_to_corner = margin_content_offset + style.spacing.section

        return {
            [edge_dir] = margins_to_edge,
            [corner_dir] = margin_to_corner
        }
    end
end
