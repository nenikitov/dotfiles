-- Load libraries
local beautiful = require('beautiful')
local lain = require('lain')
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')
local widget_utils = require('neconfig.config.utils.widget_utils')

local font_height = beautiful.get_font_height(beautiful.font)
return widget_utils.create_progress_bar(1, font_height / 4, font_height)
