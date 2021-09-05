-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_vars = require('config.user.user_vars')

-- Get variables
local startup_apps = user_vars.apps.startup_apps


-- Launch applications
for i = 1, #(startup_apps) do
    awful.spawn.with_shell(startup_apps[i])
end
