local awful = require('awful')
local gears = require('gears')
local icons = require('config.utils.icons')


-- Customize this
-- ▄▀█ █▀█ █▀█ █▀
-- █▀█ █▀▀ █▀▀ ▄█
local apps = {
    -- Applications that can be opened with shortcuts
    default_apps = {
        terminal = 'alacritty',

        text_editor = 'code',
        code_editor = 'code',
        
        browser = 'firefox'
    },
    -- Commands that will be executed on start up
    startup_apps = {
        'picom --xrender-sync-fence', --experimental-backends
        'nitrogen --restore'
    }
}


-- █▄▄ █ █▄ █ █▀▄ █▀
-- █▄█ █ █ ▀█ █▄▀ ▄█
local binds = {
    -- Special keys that are used in binds
    keys = {
        super_key = 'Mod4',
        shift_key = 'Shift',
        ctrl_key = 'Ctrl',
        alt_key = 'Mod1'
    },
    -- Other settings related to mouse and keyboard binds
    interactions = {
        enable_sloppy_focus = true
    }
}


-- █▀▄ █▀▀ █▀ █▄▀ ▀█▀ █▀█ █▀█
-- █▄▀ ██▄ ▄█ █ █  █  █▄█ █▀▀
local desktop = {
    -- Theme
    theme_path = gears.filesystem.get_themes_dir() .. 'default/theme.lua', -- os.getenv('HOME') .. '/.config/awesome/themes/netheme/theme.lua'
    -- Names (and consequently, number) of tags
    tag_names = {
        icons.home,
        icons.terminal,
        icons.code,
        icons.study,
        icons.media,
    },
    -- List of layouts that can be cycled through
    layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.spiral,
        
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


-- ▄▀█ █▀▀ ▀█▀ █ █▀█ █▄ █ █▄▄ ▄▀█ █▀█
-- █▀█ █▄▄  █  █ █▄█ █ ▀█ █▄█ █▀█ █▀▄
local actionbar = {
    -- Show the action bar
    visibility = true,
    -- Which widgets will be shown
    widgets = {
        launcher = true,
        prompt = true,
        taglist = true,
        tasklist = true
    },
    -- Position on the screen 
    position = 'bottom',
    -- Height
    height = 25
}


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Show the action bar
    visibility = true,
    -- Which widgets will be shown
    widgets = {
        layout = true,
        player = true,
        volume = true,
        internet = true,
        language = true,
        date = true,
        time = true
    },
    -- Position on the screen 
    position = 'top',
    -- Height
    height = 25
}


local user_vars = {
    apps = apps,
    binds = binds,
    desktop = desktop,
    actionbar = actionbar,
    statusbar = statusbar
}

return user_vars
