-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')


--#region Helper methods
--- Get the corner or the edge of the screen where the widget will be placed from the side and section
---@param side string Side of the screen where the bar is placed ('top', 'bottom', 'left', 'right')
---@param section number "Part" of the bar where the widget should be placed (1 for the first, 2 for the middle, 3 for the last)
---@return string
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

--- Get the direction to the next widget ('top', 'bottom', 'left', 'right')
---@param side string Side of the screen where the bar is placed ('top', 'bottom', 'left', 'right')
---@param section number "Part" of the bar where the widget should be placed (1 for the first, 2 for the middle, 3 for the last)
---@return string
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

--- Compute the margin to the edge and corners of the screen
---@param style table List of style variables
---@param side string Side of the screen where the bar is placed ('top', 'bottom', 'left', 'right')
---@return table
local function get_margins(style, side)
    local margin_edge_val = style.margin.edge + style.margin.content
    local margin_corner_val = style.margin.corners + style.spacing

    local margin_edge_dir = side
    local margin_corner_dir
    if (side == 'top' or side == 'bottom')
    then
        margin_corner_dir = { 'left', 'right' }
    else
        margin_corner_dir = { 'top', 'bottom' }
    end

    return {
        [margin_corner_dir[2]] = margin_corner_val,
        [margin_corner_dir[1]] = margin_corner_val,
        [margin_edge_dir] = margin_edge_val
    }
end

--- Compute the spacing between the current and the next widget
---@param style table List of style variables
---@param side string Side of the screen where the bar is placed ('top', 'bottom', 'left', 'right')
---@param dir string Direction to the next widget ('top', 'bottom', 'left', 'right')
---@return table
local function get_spacing(style, side, dir)
    local spacing_val = style.spacing
    local spacing_dir
    if (side == 'top' or side == 'bottom')
    then
        spacing_dir = 'x'
    else
        spacing_dir = 'y'
    end
    local dir_multiplier
    if (dir == 'left' or dir == 'top')
    then
        dir_multiplier = -1
    else
        dir_multiplier = 1
    end

    return {
        [spacing_dir] = spacing_val * dir_multiplier
    }
end


--- Add, initialize and draw a section
---@param args table Name, widget(contents), position(side, section), style, screen and info_table
function add_bar_section(args)
    if (not args.visible)
    then
        return
    end

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


    --#region Popup creation
    --#region Resize the contents
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
    --#endregion
    --#region Create the popup
    -- Function that will be used to place the widget
    local placement_func
    if (last_section_name)
    then
        placement_func = nil
    else
        placement_func = function(wi)
            local margins = get_margins(style, position.side)
            return awful.placement[corner](wi, { margins = margins })
        end
    end
    local popup = awful.popup {
        screen = screen,
        shape = r_rect(style.corner_radius),
        preferred_positions = next_dir,
        preferred_anchors = 'middle',
        bg = style.background_color,
        widget = final_widget,
        placement = placement_func,
        offset = get_spacing(style, position.side, next_dir),
        type = 'toolbar',
    }
    -- Apply the size
    --popup:_apply_size_now()
    -- Attach to the last section if exists
    if (last_section_name)
    then
        popup:move_next_to(info_table[position.section][last_section_name].popup)
    end
    --#endregion
    --#endregion

    --#region Update info table variables for next section
    info_table[position.section][name].popup = popup
    info_table[position.section][name].widget = widget
    info_table[position.section].last_section_name = name
    --#endregion
end
