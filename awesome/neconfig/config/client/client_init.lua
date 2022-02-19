-- Load libraries
local awful = require('awful')
local ruled = require('ruled')
-- Load custom modules
local client_rules = require('neconfig.config.client.client_rules')
local user_client_binds = require('neconfig.user.config.binds.user_client_binds')


-- Set default mouse bindings
client.connect_signal(
    'request::default_mousebindings',
    function()
        awful.mouse.append_client_mousebindings(
            user_client_binds.buttons
        )
    end
)

-- Set default keyboard bindings
client.connect_signal(
    'request::default_keybindings',
    function()
        awful.keyboard.append_client_keybindings(
            user_client_binds.keys
        )
    end
)

-- Apply rules
ruled.client.connect_signal(
    'request::rules',
    function ()
        ruled.client.append_rules(client_rules)
    end
)

-- Connect to other signals
require('neconfig.config.client.client_signals')

-- Add titlebars
require('neconfig.config.widgets.titlebar.titlebar_init')
