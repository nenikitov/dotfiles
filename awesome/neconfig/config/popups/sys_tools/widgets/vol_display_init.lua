-- Load libraries
local lain = require('lain')
local wibox = require('wibox')
-- Load custom modules
local icons = require('neconfig.config.utils.icons')
local widget_utils = require('neconfig.config.utils.widget_utils')


return widget_utils.create_progress_bar(icons.volume_3)
