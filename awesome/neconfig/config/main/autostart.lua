-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_conf_apps = require('neconfig.config.user.user_conf_apps')

-- Get variables
local startup_apps = user_conf_apps.startup_apps


-- Launch applications
for i = 1, #(startup_apps) do
    awful.spawn.with_shell(startup_apps[i])
end
