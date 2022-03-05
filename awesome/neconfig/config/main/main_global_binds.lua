-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_global_binds = require('neconfig.user.config.binds.user_global_binds')


-- Set default mouse bindings
awful.mouse.append_global_mousebindings(user_global_binds.buttons)
-- Set default keyboard bindings
awful.keyboard.append_global_keybindings(user_global_binds.keys)
