--  Load libraries
local gears = require('gears')
local awful = require('awful')
local user_menu = require('neconfig.config.user.user_menu')


-- Customize this
-- █▀▀ █   █▀█ █▄▄ ▄▀█ █     █▄▀ █▀▀ █▄█ █▄▄ █▀█ ▄▀█ █▀█ █▀▄   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   █ █ ██▄  █  █▄█ █▄█ █▀█ █▀▄ █▄▀   █▄█ █ █ ▀█ █▄▀ ▄█
local function get_global_buttons()
    local global_buttons = gears.table.join(
        -- Toggle menu on RMB
        awful.button(
            { }, 3,
            function()
                user_menu:toggle()
            end
        ),
        -- TODO fix this, it does not work. Mouse 4 and 5 do nothing
        -- Go to next tag on FTMB
        awful.button(
            { }, 4,
            awful.tag.viewnext
        ),
        -- Go to previous tag on BTMB
        awful.button(
            { }, 5,
            awful.tag.viewprev
        )
    )

    return global_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_global_buttons() end }
)
