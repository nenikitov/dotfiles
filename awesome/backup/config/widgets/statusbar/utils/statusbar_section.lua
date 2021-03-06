-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
local statusbar_widget = require('neconfig.config.widgets.statusbar.utils.statusbar_widget')


-- Container for class members
local statusbar_section = {}


--#region Helper methods

---Get the direction to the next widget in the section
---@param edge string Edge of the screen where the statusbar is attached (top, bottom, left, or right)
---@param position string Position of the current section (front, middle, or back)
---@return string direction (top, bottom, left, or right)
local function get_next_widget_direction(edge, position)
    local horizontal_widget_directions = {
        front = 'right',
        middle = 'right',
        back = 'left'
    }
    local vertical_widget_directions = {
        front = 'bottom',
        middle = 'right',
        back = 'top'
    }
    local widget_directions = {
        top = horizontal_widget_directions,
        bottom = horizontal_widget_directions,
        left = vertical_widget_directions,
        right = vertical_widget_directions
    }

    return widget_directions[edge][position]
end
---Get the awful placement function name
---@param edge string Edge of the screen where the statusbar is attached (top, bottom, left, or right)
---@param position string Position of the current section (front, middle, or back)
---@return string placement_name (top_left, top, top_right, ...)
local function get_first_widget_placement_name(edge, position)
    local placements = {
        top = {
            front = 'top_left',
            middle = 'top',
            back = 'top_right'
        },
        bottom = {
            front = 'bottom_left',
            middle = 'bottom',
            back = 'bottom_right'
        },
        left = {
            front = 'top_left',
            middle = 'left',
            back = 'bottom_left'
        },
        right = {
            front = 'top_right',
            middle = 'right',
            back = 'bottom_right'
        }
    }

    return placements[edge][position]
end
---Get the direction of the widgets in the statusbar
---@param edge string Edge of the screen where the statusbar is attached (top, bottom, left, or right)
---@return string direction (horizontal or vertical)
local function get_widget_direction(edge)
    local widget_directions = {
        top = 'horizontal',
        bottom = 'horizontal',
        left = 'vertical',
        right = 'vertical'
    }

    return widget_directions[edge]
end
---Calculate spacing in between popups of the sections based on screen position
---@param edge string Edge of the screen where the statusbar is attached (top, bottom, left, or right)
---@param position string Position of the current section (front, middle, or back)
---@param spacing number Target spacing between widgets
---@return table spacing Spacing table
local function get_offset_spacing(edge, position, spacing)
    spacing = spacing or 0

    local offset_param =
        (get_widget_direction(edge) == 'horizontal') and 'x' or 'y'
    local offset_sign =
        (position == 'back') and -1 or 1

    return {
        [offset_param] = spacing * offset_sign
    }
end
---Calculate margins to offset the first popup based on screen position
---@param edge string Edge of the screen where the statusbar is attached (top, bottom, left, or right)
---@param position string Position of the current section (front, middle, or back)
---@param margins table Margins to the corner and edge
---@return table margins Margin table
local function get_first_widget_margins(edge, position, margins)
    margins = margins or { corner = 0, edge = 0 }

    local corner_margins = {
        horizontal = {
            front = 'left',
            middle = 'right',
            back = 'right'
        },
        vertical = {
            front = 'top',
            middle = 'bottom',
            back = 'bottom'
        }
    }
    local corner_margin = corner_margins[get_widget_direction(edge)][position]

    return {
        [corner_margin] = margins.corner,
        [edge] = margins.edge
    }
end
--#endregion


---Update the visibility of the whole section
---@param visible boolean New visibility
function statusbar_section:set_visible(visible)
    for _, popup in ipairs(self.popups) do
        popup.visible = visible
    end
end

---Create a new statusbar sections in popups
---@param args table Widgets, style, widget_style, size, edge, position, screen
---@return table self A new instance of the popup
function statusbar_section:new(args)
    -- Reference to arguments and default values
    local widgets = args.widgets or {}
    local style = args.style or {}
    local widget_style = args.widget_style or {}
    local size = args.size
    local edge = args.edge or 'top'
    local position = args.position or 'front'
    local use_real_clip = args.use_real_clip or false
    local screen = args.screen
    -- Additional variables
    local next_widget_dir = get_next_widget_direction(edge, position)
    local widget_dir = get_widget_direction(edge)
    local popup_widgets
    -- Initialize self
    self = {
        popups = {},
        set_visible = statusbar_section.set_visible
    }

    -- Determine how to place all widgets
    if position == 'middle' then
        -- Widgets should be placed in 1 popup at the center
        local layout = wibox.layout.fixed[widget_dir](
            table.unpack(widgets)
        )
        layout.spacing = style.spacing
        popup_widgets = {
            layout
        }
    else
        -- Widgets should be placed in separate popups
        popup_widgets = widgets
    end


    -- Generate popups for widgets
    for index, widget_obj in ipairs(popup_widgets) do
        -- Get if the current widget contains special tags
        local widget_to_place
        if widget_obj.visible then
            widget_to_place = widget_obj
        else
            widget_to_place = widget_obj.widget
        end

        -- Generate a popup for the current widget
        local current_popup = statusbar_widget {
            widget = widget_to_place,
            size = widget_obj.size or size,
            direction = widget_dir,
            style = widget_obj.style or widget_style,
            use_real_clip = widget_obj.use_real_clip or use_real_clip,
            force_interactive = widget_obj.force_interactive,
            type = widget_obj.type,
            screen = screen
            --TODO add force interactive and other stuff
        }
        self.popups[index] = current_popup

        -- Place it
        if index == 1 then
            -- First widget, place in the correct place and add padding
            local placement_func = function(d)
                local corner = get_first_widget_placement_name(edge, position)
                local margins = get_first_widget_margins(edge, position, style.margins)
                return awful.placement[corner](
                    d,
                    { margins = margins }
                )
            end
            current_popup:set_placement(placement_func)
        else
            -- Any other widget, offset by using previous widget
            local previous_popup = self.popups[index - 1]
            previous_popup:_apply_size_now(true)
            current_popup.preferred_positions = next_widget_dir
            current_popup.offset = get_offset_spacing(edge, position, style.spacing)
            current_popup:move_next_to(previous_popup)
        end
    end

    return self
end

return setmetatable(
    {},
    { __call = function(_, ...) return statusbar_section:new(...) end }
)
