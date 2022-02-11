-- Load libraries
local beautiful = require('beautiful')
local lain = require('lain')
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')
local widget_utils = require('neconfig.config.utils.widget_utils')
local utils_apps = require('neconfig.config.utils.utils_apps')

local font_height = beautiful.get_font_height(beautiful.font)

local bar = widget_utils.create_progress_bar {
    bar_thickness = 1,
    circle_radius = font_height / 4,
    target_thickness = font_height,
    target_length = 1,
    max_value = 100,
    on_change = function(value)
        utils_apps.set_brightness(value)
    end
}

return bar
--[[
return wibox.widget {
    bar,

    layout = wibox.layout.fixed.horizontal
}
]]