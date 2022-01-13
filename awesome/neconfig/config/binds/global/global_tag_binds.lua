-- Load libraries
local awful = require('awful')
local gears = require('gears')
-- Load custom modules
local binds_user_conf = require('neconfig.config.user.binds_user_conf')
local desktop_user_conf = require('neconfig.config.user.desktop_user_conf')

-- Get variables
local super_key = binds_user_conf.keys.super_key
local ctrl_key = binds_user_conf.keys.ctrl_key
local shift_key = binds_user_conf.keys.shift_key
local alt_key = binds_user_conf.keys.alt_key
local tag_num = #(desktop_user_conf.tag_names)


-- Bind all key numbers to interact with corresponding tags
local tag_binds = {}
for i = 1, tag_num do
    local current_tag_binds = {
        -- View tag only on SUPER + NUMBER
        awful.key(
            { super_key }, '#' .. i + 9,
            function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        tag:view_only()
                    end
            end,
            { description = 'view tag #' .. i, group = 'tag' }
        ),
        -- Toggle tag display on SUPER + CTRL + NUMBER
        awful.key(
            { super_key, ctrl_key }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = 'toggle tag #' .. i, group = 'tag' }
        ),
        -- Move client to tag on SUPER + SHIFT + NUMBER
        awful.key(
            { super_key, shift_key }, '#' .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = 'move focused client to tag #'..i, group = 'tag' }
        ),
        -- Toggle tag on focused client on SUPER + CTRL + SHIFT + NUMBER
        awful.key(
            { super_key, ctrl_key, shift_key }, '#' .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = 'toggle focused client on tag #' .. i, group = 'tag' }
        )
    }

    for _, tag_bind in ipairs(current_tag_binds) do
        table.insert(tag_binds, tag_bind)
    end
end

return tag_binds
