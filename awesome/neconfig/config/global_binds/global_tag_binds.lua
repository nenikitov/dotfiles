-- Load libraries
local awful = require('awful')
local gears = require('gears')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')

-- Get variables
local super_key = user_vars_conf.binds.keys.super_key
local ctrl_key = user_vars_conf.binds.keys.ctrl_key
local shift_key = user_vars_conf.binds.keys.shift_key
local alt_key = user_vars_conf.binds.keys.alt_key
local tag_num = #(user_vars_conf.desktop.tag_names)


-- Bind all key numbers to interact with corresponding tags
local function get_tag_binds(global_keys)
    for i = 1, tag_num do
        global_keys = gears.table.join(global_keys,
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
        )
    end

    return global_keys
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tag_binds(...) end }
)
