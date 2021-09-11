local awful = require('awful')
local icons = require('neconfig.config.utils.icons')


-- Customize this
-- ▄▀█ █▀█ █▀█ █▀
-- █▀█ █▀▀ █▀▀ ▄█
local apps = {
    -- Applications that can be opened with shortcuts
    default_apps = {
        terminal = 'alacritty',

        code_editor = 'code',
        text_editor = 'code',
        
        browser = 'firefox',

        file_manager = 'pcmanfm',
        multimedia = 'vlc'
    },
    -- Commands that will be executed on start up
    startup_apps = {
        'nitrogen --restore',
        'picom --xrender-sync-fence --experimental-backends',
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
    theme_path = os.getenv('HOME') .. '/.config/awesome/neconfig/theme/theme.lua', -- gears.filesystem.get_themes_dir() .. 'default/theme.lua'
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


-- █▀ ▀█▀ ▄▀█ ▀█▀ █ █ █▀ █▄▄ ▄▀█ █▀█
-- ▄█  █  █▀█  █  █▄█ ▄█ █▄█ █▀█ █▀▄
local statusbar = {
    -- Show the status bar
    visibility = true,
    -- Which widgets will be shown
    widgets = {
        layout = true,
        taglist = true,
        tasklist = true,
        system_tools = true,
        notifications = true,
        keyboard_layout = true,
        clock = true
    },
    datetime_format = '%H:%M, %a, %Y-%m-%d'
}


-- ▄▀█ █▀█ █▀█ █▄▄ ▄▀█ █▀█
-- █▀█ █▀▀ █▀▀ █▄█ █▀█ █▀▄
local appbar = {
    -- Show the application bar
    visibility = true,-- Load libraries
    -- Widgets that will be shown
    widgets = {
        launcher = true,
        terminal = true,
        code_editor = true,
        text_editor = true,
        broser = true,
        file_manager = false,
        multimedia = false
    }
}


local user_vars_conf = {
    apps = apps,
    binds = binds,
    desktop = desktop,
    statusbar = statusbar,
    appbar = appbar
}

return user_vars_conf
