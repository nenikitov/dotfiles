-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_desktop = require('neconfig.user.config.user_desktop')


-- Set default layouts the old way
awful.layout.layouts = user_desktop.layouts

-- ! New way, seems to be bugged, uncomment when updated
--[[
tag.connect_signal(
    'request::default_layouts',
        awful.layout.append_default_layouts(user_desktop.layouts)
    end
)
]]
