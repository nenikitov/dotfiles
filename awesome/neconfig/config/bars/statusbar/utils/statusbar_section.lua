-- Load libraries
local awful = require('awful')
-- Load custom modules
local statusbar_widget = require('neconfig.config.bars.statusbar.utils.statusbar_widget')


-- Container for class members
local statusbar_section = {}


--#region Helper methods
local function get_next_widget_direction(edge, position)
    local horizontal_widget_directions = {
        front = 'right',
        middle = 'none',
        back = 'left'
    }
    local vertical_widget_directions = {
        front = 'bottom',
        middle = 'none',
        back = 'top'
    }
    local widget_directions = {
        top = vertical_widget_directions,
        bottom = vertical_widget_directions,
        left = horizontal_widget_directions,
        right = horizontal_widget_directions
    }

    return widget_directions[edge][position]
end
--#endregion


function statusbar_section:new(args)
    -- Reference to arguments and default values
    local widgets = args.widgets
    local style = args.style or {}
    local widget_style = args.style or {}
    local size = args.size
    local edge = args.edge or 'top'
    local position = args.position or 'right'
    -- Additional variables
    local next_widget_dir = get_next_widget_direction(edge, position)
    local first_widget_placed = false
    -- Instance variables
    self.popups = {}

    -- Generate popups for each widget inside widgets
    for index, widget in ipairs(widgets) do
        self.popups[index] = statusbar_widget {
            widget = widget,
            size = size
        }

        if index == 1 then
            -- First widget, add padding
            self.popups[index]:set_placement(awful.placement.centered)
        else
            -- Any other widget, offset by using previous widget
            self.popups[index - 1]:_apply_size_now(true)
            self.popups[index]:move_next_to(self.popups[index - 1])
        end
    end

    return self
end

return setmetatable(
    {},
    { __call = function(_,...) return statusbar_section:new(...) end }
)
