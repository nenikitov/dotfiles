local awful = require('awful')
local icons = require('neconfig.config.utils.icons')
local config_path = os.getenv('HOME') .. '/.config/awesome/'


-- Customize this
-- ▄▀█ █▀█ █▀█ █▀
-- █▀█ █▀▀ █▀▀ ▄█
local apps = {
    -- Applications that can be opened with shortcuts
    -- TODO implement this
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
        'numlockx on',
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
    theme_path = config_path .. 'neconfig/theme/theme.lua', -- gears.filesystem.get_themes_dir() .. 'default/theme.lua'
    -- Names (and consequently number) of tags
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
        awful.layout.suit.spiral,
        awful.layout.suit.tile,

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
    -- Show the status bar by default (statusbar can still be toggled with a keyboard shortcut)
    visible = true,
    -- Widget settings
    widgets = {
        -- Open menu widget
        menu = {
            -- Should it be shown
            visible = true
        },
        -- Current desktop layout
        layoutbox = {
            -- Should it be shown
            visible = true
        },
        -- List of tags (virtual desktops)
        taglist = {
            -- Should it be shown
            visible = true,
            -- Should the small dots under the tag be shown to indicate the number of tagged clients
            show_client_count = true
        },
        -- List of tasks (opened apps)
        tasklist = {
            -- Should it be shown
            visible = true,
            -- Should the name of the task be shown
            show_task_title = true,
            -- Should the property (maximized, on top, etc) be shown
            show_task_props = true
        },
        -- Current keyboard layout
        keyboard_layout = {
            -- Should it be shown
            visible = true,
        },
        -- Analog clock
        clock = {
            -- Should it be shown
            visible = true,
            -- Format of the time written on the top
            top_format = '%H:%M',
            -- Format of the time written on the bottom
            bottom_format = '%a %Y-%m-%d',
        }
    },
}


local user_vars_conf = {
    apps = apps,
    binds = binds,
    desktop = desktop,
    statusbar = statusbar
}

return user_vars_conf
