-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
-- Global variables
local modkey = rc.uservars.modkey

function getbindtotags(globalkeys)
    -- Bind all key numbers to interact with corresponding tags
    for i = 1, rc.tagnum do
        globalkeys = gears.table.join(globalkeys,
            -- View tag only on MOD + NUMBER
            awful.key(
                { modkey }, "#" .. i + 9,
                function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            tag:view_only()
                        end
                end,
                { description = "view tag #"..i, group = "tag" }
            ),
            -- Toggle tag display on MOD + CTRL + NUMBER
            awful.key(
                { modkey, "Control" }, "#" .. i + 9,
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        awful.tag.viewtoggle(tag)
                    end
                end,
                { description = "toggle tag #" .. i, group = "tag" }
            ),
            -- Move client to tag on MOD + SHIFT + NUMBER
            awful.key(
                { modkey, "Shift" }, "#" .. i + 9,
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                    end
                end,
                { description = "move focused client to tag #"..i, group = "tag" }
            ),
            -- Toggle tag on focused client on MOD + CTRL + SHIFT + NUMBER
            awful.key(
                { modkey, "Control", "Shift" }, "#" .. i + 9,
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end,
                { description = "toggle focused client on tag #" .. i, group = "tag" }
            )
        )
    end

    return globalkeys
end

return setmetatable(
    {},
    {  __call = function(_, ...) return getbindtotags(...) end }
)
