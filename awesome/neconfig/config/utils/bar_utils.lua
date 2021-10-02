-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')


--#region Helper methods
--- Generate the position string from a side where the bar is attached and section index
---@param side string 'top', 'bottom', 'left', 'right'
---@param section number 1, 2, 3 where, in case of 'top' side, 1 is left corner, 2 is middle and 3 is right corner
---@return table position_info Where the widget should be located and what is the direction to the next widget
local function generate_position_info(side, section)
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
local function find_margins_for_position(position, last_section, style, screen, info_table)
    -- Precalculate all values
    local position_info = generate_position_info(position.side, position.section)

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
        margin_to_corner = margin_content_offset + style.spacing

        return {
            [edge_dir] = margins_to_edge,
            [corner_dir] = margin_to_corner
        }
    end
end
--#endregion

-- TODO
-- Remake completely how the bar sections are attach
-- There is no need to set the margins depending on the previous widget
-- You can simply attach the current one to the previous by using `current:move_next_to(last)`
-- The problem is some widgets have uninitialized size, so you need to init it manually with `last:_apply_size_now()`
-- This feels like a hack, but it is less hacky then what i have now



local function get_corner(side, section)
        local lookup = {
        ['top'] = {
            [1] = 'top_left',
            [2] = 'top',
            [3] = 'top_right'
        },
        ['bottom'] = {
            [1] = 'bottom_left',
            [2] = 'bottom',
            [3] = 'bottom_right'
        },
        ['left'] = {
            [1] = 'top_left',
            [2] = 'left',
            [3] = 'bottom_left'
        },
        ['right'] = {
            [1] = 'top_right',
            [2] = 'right',
            [3] = 'bottom_right'
        }
    }

    return lookup[side][section]
end


local function get_next_widget_dir(side, section)
    local lookup = {
        ['top'] = {
            [1] = 'right',
            [2] = 'right',
            [3] = 'left'
        },
        ['bottom'] = {
            [1] = 'right',
            [2] = 'right',
            [3] = 'left'
        },
        ['left'] = {
            [1] = 'bottom',
            [2] = 'bottom',
            [3] = 'top'
        },
        ['right'] = {
            [1] = 'bottom',
            [2] = 'bottom',
            [3] = 'top'
        }
    }

    return lookup[side][section]
end


--- Add, initialize and draw a section
---@param args table Name, widget(contents), position(side, section), style, screen and info_table
function add_bar_section(args)
    --#region Aliases for the arguments
    local name = args.name
    local widget = args.widget
    local position = args.position
    local style = args.style
    local screen = args.screen
    local info_table = args.info_table
    -- Precalculate position info
    local corner = get_corner(position.side, position.section)
    local next_dir = get_next_widget_dir(position.side, position.section)
    --#endregion


    --#region Init the section table
    -- The container for this corner if it is the first widget to be placed
    if (not info_table[position.section])
    then
        info_table[position.section] = {
            last_section_name = nil
        }
    end
    -- Get the last section if exists
    local last_section_name = info_table[position.section].last_section_name
    -- The container for this bar section
    info_table[position.section][name] = {
        popup = {},
        widget = {}
    }
    --#endregion


    --#region Create popup
    -- Resize the widget
    local padding_ver
    local padding_hor
    local resize_func
    if (next_dir == 'top' or next_dir == 'bottom')
    then
        padding_ver = style.corner_radius
        padding_hor = 0
        resize_func = set_width_widget
    else
        padding_ver = 0
        padding_hor = style.corner_radius
        resize_func = set_height_widget
    end
    local final_widget = {
        pad_widget(
            {
                resize_func(widget, style.contents_size),
                widget = wibox.container.background
            },
            padding_ver, padding_hor,
            padding_ver, padding_hor
        ),

        layout = wibox.layout.fixed.horizontal,
    }
    -- Create the popup
    local placement_func
    if (last_section_name)
    then
        placement_func = nil
    else
        placement_func = awful.placement.top_right
    end
    local popup = awful.popup {
        screen = screen,
        shape = r_rect(style.corner_radius),
        preferred_positions = 'left',
        preferred_anchors = 'middle',
        bg = style.background_color,
        widget = final_widget,
        -- x = screen.geometry.x + 40,
        type = 'toolbar',
        placement = placement_func
    }
    -- Apply the size
    --popup:_apply_size_now()
    -- Attach to the last section if exists
    if (name ~= 'clock')
    then
        popup:move_next_to(info_table[3]['clock'].popup)
    end
    --#endregion

    --#region Update info table variables for next section
    info_table[position.section][name].popup = popup
    info_table[position.section][name].widget = widget
    info_table[position.section].last_section_name = name
    --#endregion
end
