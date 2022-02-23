-- Load libraries
local awful = require('awful')
-- Load custom modules
local icons = require('neconfig.user.config.user_icons')


-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀
local desktop = {
    -- Names (and consequently the number) of tags
    tag_names = {
        icons.home,
        icons.terminal,
        icons.code,
        icons.globe,
        icons.media,
        icons.communication,
    },
    -- List of layouts that can be cycled through
    -- (the first one is selected by default)
    layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.corner.nw,
        awful.layout.suit.max,
        awful.layout.suit.floating,

        --[[ All available layouts
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.floating,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
        awful.layout.suit.corner.ne,
        awful.layout.suit.corner.sw,
        awful.layout.suit.corner.se,
        ]]
    }
}

return desktop
