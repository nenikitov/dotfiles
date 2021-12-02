-- Load libraries
local awful = require('awful')

-- Get variables
local icons = require('neconfig.config.utils.icons')
local config_path = os.getenv('HOME') .. '/.config/awesome/'


-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀
local desktop = {
    -- Path to the theme
    theme_path = config_path .. 'neconfig/theme/theme.lua',
    -- Names (and consequently number) of tags
    tag_names = {
        icons.home,
        icons.terminal,
        icons.code,
        icons.globe,
        icons.media,
        icons.communication,
    },
    -- List of layouts that can be cycled through
    -- (the first is selected by default)
    layouts = {
        awful.layout.suit.spiral,
        awful.layout.suit.tile,
        awful.layout.suit.floating,

        --[[ All available layouts
            awful.layout.suit.tile
            awful.layout.suit.tile.left
            awful.layout.suit.tile.bottom
            awful.layout.suit.tile.top
            awful.layout.suit.fair
            awful.layout.suit.fair.horizontal
            awful.layout.suit.floating
            awful.layout.suit.spiral
            awful.layout.suit.spiral.dwindle
            awful.layout.suit.max
            awful.layout.suit.max.fullscreen
            awful.layout.suit.magnifier
            awful.layout.suit.corner.nw
            awful.layout.suit.corner.ne
            awful.layout.suit.corner.sw
            awful.layout.suit.corner.se
        -- ]]
    }
}

return desktop
