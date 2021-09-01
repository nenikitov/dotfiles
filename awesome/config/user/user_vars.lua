local awful = require('awful')
local icons = require('config.utils.icons')


-- Customize this
-- ▄▀█ █▀█ █▀█ █▀
-- █▀█ █▀▀ █▀▀ ▄█
-- Applications that can be opened with shortcuts
local default_apps = {
    terminal = 'alacritty',

    text_editor = 'code',
    code_editor = 'code',
    
    browser = 'firefox'
}
-- Commands that will be executed on start up
local startup_apps = {
    'picom --xrender-sync-fence', --experimental-backends
    'nitrogen --restore'
}

-- █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █ █ ▀█ █▄▀ ▄█
-- Special keys that are used in binds
local keys = {
    super_key = 'Mod4',
    shift_key = 'Shift',
    ctrl_key = 'Ctrl',
    alt_key = 'Mod1'
}
-- Other settings related to mouse and keyboard binds
local interactions = {
    enable_sloppy_focus = true
}

-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀
-- List of layouts that can be cycled through
local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.spiral
    
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
-- Names (and consequently, number) of tags
local tag_names = {
    icons.home,
    icons.terminal,
    icons.code,
    icons.study,
    icons.media,
}
-- Theme
local theme_path = os.getenv("HOME") .. '/.config/awesome/themes/netheme/theme.lua'


local user_vars = {
    apps = {
        default_apps = default_apps,
        startup_apps = startup_apps
    },
    binds = {
        keys = keys,
        interactions = interactions
    },
    desktop = {
        layouts = layouts,
        tag_names = tag_names,
        theme_path = theme_path
    }
}
return user_vars
