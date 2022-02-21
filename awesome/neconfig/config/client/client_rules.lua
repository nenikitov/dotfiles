-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
-- Load custom modules
local client_buttons = require('neconfig.user.config.binds.user_client_binds').buttons
local client_keys = require('neconfig.user.config.binds.user_client_binds').keys


-- Rules to apply to new clients (through the 'manage' signal).
-- TODO write custom rules
local rules = {
    -- All clients will match this rule.
    {
        id = 'global',
        rule = { },
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Floating clients
    {
        id = 'floating',
        rule_any = {
            class = {
                'Arandr'
            },
            role = {
                'pop-up'
            }
        },
        properties = {
            floating = true
        }
    },
    -- Add titlebars to normal clients and dialogs
    {
        id = 'titlebars',
        rule_any = {
            type = {
                'normal',
                'dialog'
            }
        },
        properties = {
            titlebars_enabled = true
        }
    },
}

return rules
