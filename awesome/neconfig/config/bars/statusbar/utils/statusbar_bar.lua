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

local function get_thickness_param(position)
    local thickness_params = {
        top = 'height',
        bottom = 'height',
        left = 'width',
        right = 'width'
    }

    return thickness_params[position]
end

local function get_length_param(position)
    local length_params = {
        top = 'width',
        bottom = 'width',
        left = 'height',
        right = 'height'
    }

    return length_params[position]
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
    style.margins = style.margins or {}
    style.margins.edge = style.margins.edge or 0
    style.margins.corner = style.margins.corner or 0
    style.padding = style.padding or {}
    style.padding.edge = style.padding.edge or 0
    style.padding.corner = style.padding.corner or 0
    local use_real_clip = args.use_real_clip or false
    local section_style = args.section_style or {}
    local contents_size = args.contents_size or beautiful.get_font_height(beautiful.font)
    local section_use_real_clip = args.section_use_real_clip
    local screen = args.screen
    -- Additional variables
    local wibar_shape = get_wibar_shape(use_real_clip, shape)
    local thickness_param = get_thickness_param(position)
    local length_param = get_length_param(position)
    section_style.margins = {
        edge = style.margins.edge + style.padding.edge,
        corner = style.margins.corner + style.padding.corner
    }

    require('naughty').notify {
        text = tostring(style.margins.corner)
    }

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
        [thickness_param] = contents_size + style.padding.edge * 2,
        [length_param] = screen.geometry[length_param] - style.margins.corner * 2,
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
