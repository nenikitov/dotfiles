-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
local statusbar_section = require('neconfig.config.bars.statusbar.utils.statusbar_section')


-- Container for class members
local statusbar_bar = {}


--#region Helper methods

---Find the shape of the wibar from use real clip setting
---@param use_real_clip boolean If the shape should be really cut of with no anti-aliasing
---@param target_shape function The function of the shape that the popup supposed to be
---@return function shape The correct shape of the popup
local function get_wibar_shape(use_real_clip, target_shape)
    if use_real_clip == nil or use_real_clip then
        return target_shape
    else
        return nil
    end
end
--#endregion

function statusbar_bar:new(args)
    -- Reference to arguments and default values
    local front_widgets = args.front_widgets
    local middle_widgets = args.middle_widgets
    local back_widgets = args.back_widgets
    local shape = args.shape
    local position = args.position or 'top'
    local style = args.style or {}
    local use_real_clip = args.use_real_clip or false
    local section_style = args.style
    local contents_size = args.contents_size
    local section_use_real_clip = args.section_use_real_clip
    local screen = args.screen
    -- Additional variables
    local wibar_shape = get_wibar_shape(use_real_clip, shape)


    -- Generate wibar
    self.wibar = awful.wibar {
        widget = {
            widget = wibox.container.background,

            bg = style.bg,
            shape = shape,
        },
        screen = screen,
        bg = '#0000',
        shape = wibar_shape,
        position = position
    }

    -- Generate sections
    self.front_section = statusbar_section {
        widgets = front_widgets,
        style = section_style,
        size = contents_size,
        edge = position,
        position = 'front',
        screen = args.screen
    }


    return self
end

return setmetatable(
    {},
    { __call = function(_,...) return statusbar_bar:new(...) end }
)
