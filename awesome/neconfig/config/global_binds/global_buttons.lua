-- Load libraries
local awful = require('awful')
local gears = require('gears')
-- Load custom modules
local menu_user_conf = require('neconfig.config.user.menu_user_conf')



-- █▀▀ █   █▀█ █▄▄ ▄▀█ █     █▀▄▀█ █▀█ █ █ █▀ █▀▀   █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   █ ▀ █ █▄█ █▄█ ▄█ ██▄   █▄█ █ █ ▀█ █▄▀ ▄█
local function get_global_buttons()
    local global_buttons = gears.table.join(
        -- Toggle menu on RMB
        awful.button(
            { }, 3,
            function()
                menu_user_conf:toggle()
            end
        ),
        -- Go to next tag on SCROLL UP
        awful.button(
            { }, 4,
            awful.tag.viewnext
        ),
        -- Go to previous tag on SCROLL DOWN
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
