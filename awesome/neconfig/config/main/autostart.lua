-- Load libraries
local awful = require('awful')
-- Load custom modules
local user_apps = require('neconfig.user.config.user_apps')

-- Get variables
local startup = user_apps.startup


-- Launch applications
for i = 1, #(startup) do
    awful.spawn.with_shell(startup[i])
end
