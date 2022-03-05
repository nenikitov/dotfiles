-- Load libraries
local awful = require('awful')

-- █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▀█ █ █ █   █▀▀ █▀
-- █▄▄ █▄▄ █ ██▄ █ ▀█  █    █▀▄ █▄█ █▄▄ ██▄ ▄█
local rules = {
    --#region Rules for all clients
    {
        id = 'global',
        rule = { },
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false,
        }
    },
    --#endregion

    --#region Add titlebars to normal clients and dialogs
    -- All the clients specified here have the titlebar that can be hidden with a shortcut
    -- If you don't want the titlebars enabled by default, but want to keep the shortcut, change the setting 'visible' in user/config/widget/user_titlebar.lua
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
    --#endregion

    --#region Floating clients
    {
        id = 'floating',
        rule_any = {
            class = {
                'Nitrogen',
                'Qalculate-gtk',
                'Arandr'
            }
        },
        properties = {
            floating = true,
        }
    },
    --#endregion
}

return rules
