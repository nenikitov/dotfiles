-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
require('neconfig.config.utils.widget_utils')

-- Get style
local style = beautiful.user_vars_theme.statusbar


--#region Helper methods

--- Get the corner or the edge of the screen where the widget will be placed from the side and section
---@param section number "Part" of the bar where the widget should be placed (1 for the first, 2 for the middle, 3 for the last)
---@return string
local function get_corner(section)
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

    return lookup[style.position][section]
end

--- Get the direction to the next widget ('top', 'bottom', 'left', 'right')
---@param section number "Part" of the bar where the widget should be placed (1 for the first, 2 for the middle, 3 for the last)
---@return string
local function get_next_widget_dir(section)
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

    return lookup[style.position][section]
end

--- Compute the margin to the edge and corners of the screen
---@return table
local function get_margins()
    local margin_edge_val = style.margin.edge + style.margin.content
    local margin_corner_val = style.margin.corners + style.spacing

    local margin_edge_dir = style.position
    local margin_corner_dir
    if (style.position == 'top' or style.position == 'bottom')
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
---@param dir string Direction to the next widget ('top', 'bottom', 'left', 'right')
---@return table
local function get_spacing(dir)
    local spacing_val = style.spacing
    local spacing_dir
    if (style.position == 'top' or style.position == 'bottom')
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
--#endregion


function add_background_bar(args)
    --#region Aliases for the arguments
    local screen = args.screen
    local sections = args.sections
    local info_table = args.info_table
    -- Precalculate bar info
    local bar_size = style.contents_size + style.margin.content * 2
    local bar_param_size = {
        length =    (style.position == 'top' or style.position == 'bottom') and 'width'  or 'height',
        thickness = (style.position == 'top' or style.position == 'bottom') and 'height' or 'width',
    }
    local bar_offset_dir = (style.position == 'top' or style.position == 'left') and 1 or -1
    local bar_param_offset = (style.position == 'top' or style.position == 'bottom') and 'y' or 'x'
    --#endregion

    local wibar = awful.wibar {
        position = style.position,
        screen = screen,
        [bar_param_size.thickness] = bar_size,
        [bar_param_size.length] = screen.geometry[bar_param_size.length] - style.margin.corners * 2,

        shape = r_rect(style.corner_radius.bar),
    }
    -- Offset the bar
    wibar[bar_param_offset] = wibar[bar_param_offset] + bar_offset_dir * style.margin.edge
    -- Modify the area where clients can be placed
    wibar:struts {
        [style.position] = style.margin.edge + bar_size
    }
    -- Hide all the widgets inside the wibar if wibar is hidden
    wibar:connect_signal(
        'property::visible',
        function ()
            local new_visibility = wibar.visible
            -- Cycle through each widget
            for _, section in pairs(sections) do
                for _, popup in pairs(section) do
                    if (popup.visible ~= nil)
                    then
                        popup.visible = new_visibility
                    end
                end
            end
        end
    )

    info_table.wibar = wibar
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
    local section = args.section
    local force_interactive = args.force_interactive
    local screen = args.screen
    local info_table = args.info_table
    -- Precalculate position info
    local corner = get_corner(section)
    local next_dir = get_next_widget_dir(section)
    --#endregion


    --#region Init the section table
    -- The container for this corner if it is the first widget to be placed
    if (not info_table[section])
    then
        info_table[section] = {
            last_section_name = nil
        }
    end
    -- Get the last section if exists
    local last_section_name = info_table[section].last_section_name
    -- The container for this bar section
    info_table[section][name] = nil
    -- The list of all sections
    if (not info_table.all_popups)
    then
        info_table.all_popups = {}
    end
    --#endregion


    --#region Create popup
    --#region Set up contents
    -- Calculate padding and size
    local padding_ver = (next_dir == 'top' or next_dir == 'bottom') and style.corner_radius.sections or 0
    local padding_hor = (next_dir == 'left' or next_dir == 'right') and style.corner_radius.sections or 0
    local resize_func = (next_dir == 'top' or next_dir == 'bottom') and set_width_widget or set_height_widget
    -- Construct the widget
    local final_widget = {
        {
            pad_widget(
                {
                    resize_func(widget, style.contents_size),
                    widget = wibox.container.background
                },
                padding_ver, padding_hor,
                padding_ver, padding_hor
            ),

            layout = wibox.layout.fixed.horizontal,
        },

        widget = wibox.container.background,
        shape = r_rect(style.corner_radius.sections),
        shape_clip = true,
        bg = style.colors.bg_sections
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
            local margins = get_margins()
            return awful.placement[corner](wi, { margins = margins })
        end
    end
    -- Get the shape
    local shape
    if (style.real_clip.sections)
    then
        shape = r_rect(style.corner_radius.sections)
    else
        shape = nil
    end
    -- Construct popup
    local popup = awful.popup {
        screen = screen,
        preferred_positions = next_dir,
        preferred_anchors = 'middle',
        bg = '#00000000',
        shape = shape,
        widget = final_widget,
        placement = placement_func,
        offset = get_spacing(next_dir),
        type = 'toolbar',
    }
    -- Apply the size
    -- ? May be needed : popup:_apply_size_now()
    -- Attach to the last section if exists
    if (last_section_name)
    then
        popup:move_next_to(info_table[section][last_section_name])
    end
    -- Improve user experience with popups that contain interactive widgets
    -- By changing the cursor and making click area bigger
    if (#widget.buttons ~= 0 or force_interactive == true)
    then
        popup.cursor = 'hand1'
        popup.buttons = widget.buttons
        widget.buttons = {}
    end
    --#endregion
    --#endregion

    --#region Update info table variables for next section
    info_table[section][name] = popup
    info_table.all_popups[name] = popup
    info_table[section].last_section_name = name
    --#endregion
end
