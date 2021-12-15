-- Load libraries
local awful = require('awful')
-- Load custom modules
local apps_user_conf = require('neconfig.config.user.apps_user_conf')

-- Get variables
local startup_apps = apps_user_conf.startup_apps


-- Launch applications
for i = 1, #(startup_apps) do
    awful.spawn.with_shell(startup_apps[i])
end
