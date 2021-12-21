-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')


-- Container for class members
local statusbar_section = {}


---Find the size parameter which should be forced for a direction
---@param direction string Direction of the widget ('vertical' or 'horizontal')
---@return string size_constraint Size parameter ('width' or 'height')
local function get_size_constraint(direction)
    local size_constraints = {
        horizontal = 'height',
        vertical = 'width'
    }
    return size_constraints[direction]
end

---Find the sides of the widget for a direction
---@param direction string Direction of the widget ('vertical' or 'horizontal')
---@return table widget_directions Table containing the 'front' and the 'back' direction (which are 'top', 'bottom', 'left', or 'right')
local function get_widget_dirs(direction)
    local horizontal_widget_directions = {
        front = 'right',
        back = 'left'
    }
    local vertical_widget_directions = {
        front = 'bottom',
        back = 'top'
    }

    local widget_directions = {
        horizontal = horizontal_widget_directions,
        vertical = vertical_widget_directions
    }

    return widget_directions[direction]
end


local function get_popup_shape(use_real_clip, target_shape)
    if use_real_clip == nil or use_real_clip then
        return target_shape
    else
        return nil
    end
end


function statusbar_section:new(args)
    -- Reference to arguments and default values
    local widget = args.widget
    local style = args.style or {}
    local size = args.size or beautiful.get_font_height(beautiful.font)
    local direction = args.direction or 'horizontal'
    local use_real_clip = args.use_real_clip
    local force_interactive = args.force_interactive
    local type = args.type or 'toolbar'
    local screen = args.screen
    -- Additional variables
    local size_constraint = get_size_constraint(direction)
    local padding_dirs = get_widget_dirs(direction)
    local popup_shape = get_popup_shape(use_real_clip, style.shape)

    -- Resize and pad the widget
    local final_widget = {
        {
            {
                widget,

                widget = wibox.container.margin,
                [padding_dirs.front] = style.padding,
                [padding_dirs.back] = style.padding
            },

            widget = wibox.container.background,
            ['forced_' .. size_constraint] = size
        },

        widget = wibox.container.background,
        bg = style.bg,
        shape = style.shape,
        shape_clip = true,
    }


    -- Generate a popup
    self = awful.popup {
        screen = screen,
        bg = '#00000000',
        shape = popup_shape,
        widget = final_widget,
        type = type
    }

    -- If the widget is interactive (or forced to be), pass all the input to the popup rather than to the widget and force 'hand' cursor
    if #widget.buttons ~= 0 or force_interactive == true then
        self.cursor = 'hand1'
        self.buttons = widget.buttons
        widget.buttons = {}
    end

    return self
end

return setmetatable(
    {},
    { __call = function(_,...) return statusbar_section:new(...) end }
)
