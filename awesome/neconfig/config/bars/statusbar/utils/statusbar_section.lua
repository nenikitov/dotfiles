-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
-- Load custom modules
local statusbar_widget = require('neconfig.config.bars.statusbar.utils.statusbar_widget')


-- Container for class members
local statusbar_section = {}


--#region Helper methods
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
local function get_placement(edge, position)
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
--#endregion


function statusbar_section:new(args)
    -- Reference to arguments and default values
    local widgets = args.widgets
    local style = args.style or {}
    local widget_style = args.style or {}
    local size = args.size
    local edge = args.edge or 'top'
    local position = args.position or 'front'
    -- Additional variables
    local next_widget_dir = get_next_widget_direction(edge, position)
    -- Instance variables
    self.popups = {}

    -- Generate popups for each widget inside widgets
    if position == 'middle' then
        local all_widgets_together = wibox.layout.fixed.horizontal()
        for _, widget in ipairs(widgets) do
            all_widgets_together:add(widget)
        end
        local current_popup = statusbar_widget {
            widget = all_widgets_together,
            size = size
        }
        local placement_func = awful.placement[get_placement(edge, position)]
        current_popup:set_placement(placement_func)
        self.popups[1] = current_popup
    else
        for index, widget in ipairs(widgets) do
            local current_popup = statusbar_widget {
                widget = widget,
                size = size
            }
            self.popups[index] = current_popup

            if index == 1 then
                -- First widget, place in the correct place and add padding
                local placement_func = awful.placement[get_placement(edge, position)]
                current_popup:set_placement(placement_func)
            else
                -- Any other widget, offset by using previous widget
                local previous_popup = self.popups[index - 1]
                previous_popup:_apply_size_now(true)
                current_popup.preferred_positions = next_widget_dir
                current_popup:move_next_to(previous_popup)
            end
        end
    end

    return self
end

return setmetatable(
    {},
    { __call = function(_,...) return statusbar_section:new(...) end }
)
