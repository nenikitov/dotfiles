-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')


-- Add, initialize and draw a section onto a custom bar
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
    local last_section = info_table[section_position].last_section


    info_table[section_position][name] = {
        popup = {},
        contents = {}
    }


    -- Create the popup
    info_table[section_position][name].popup = awful.popup {
        screen = screen,
        placement = function(wi)
            local margins = find_margins_for_position(position, last_section, style, screen, info_table)

            return awful.placement[section_position](
                wi,
                { margins = margins }
            )
        end,
        widget = {}
    }

    -- Populate it with widgets
    info_table[section_position][name].widgets = widgets
    -- Precalculate needed values
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
function find_margins_for_position(position, last_section, style, screen, info_table)
    local position_info = generate_positon(position.side, position.section)
    
    local dir = position_info.next_direction
    local pos = position_info.combined

    local bar_position_dir = position.side
    local section = position.section

    -- Calculate the margin to the side of the screen where the section (and the bar) are attached
    local margins_to_bar = style.margin.edge * 2


    -- Margin to the corner where the section is attached
    local margin_to_content
    if (section == 2)
    then
        -- If the section is in the middle, just put it in the center without any content offset
        return {
            [bar_position_dir] = margins_to_bar
        }
    else
        -- Calculate the margin to the corner where the section is attached
        -- Find its location
        local lookup_margin_before = {
            ['top'] = 'bottom',
            ['bottom'] = 'top',
            ['left'] = 'right',
            ['right'] = 'left'
        }
        local margin_before_dir = lookup_margin_before[dir]
        -- Calculate the offset of this margin (depends on the section that was placed before)
        local margin_content_offset = 0
        -- Check last placed section
        if (not last_section)
        then
            -- There was no sections placed in this corner, the margin depends on the bar
            margin_content_offset = style.margin.corners
        else
            -- Offset the current section so it does not overlap with previous
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
        margin_to_content = margin_content_offset + style.spacing.section

        return {
            [bar_position_dir] = margins_to_bar,
            [margin_before_dir] = margin_to_content
        }
    end
end
