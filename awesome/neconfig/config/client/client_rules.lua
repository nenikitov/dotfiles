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
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_keys,
            buttons = client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Floating clients
    {
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
        rule_any = {
            type = { 'normal', 'dialog' }
        },
        properties = {
            titlebars_enabled = true
        }
    }
}

return rules
