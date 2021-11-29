-- Load libraries
local awful = require('awful')

-- Get variables
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

        run_menu = 'rofi -show drun -theme grid.rasi',

        code_editor = 'code',
        text_editor = 'code',

        browser = 'firefox',

        file_manager = 'pcmanfm',
        multimedia = 'vlc'
    },
    -- Commands that will be executed on start up
    startup_apps = {
        'nitrogen --set-zoom-fill --random ~/Pictures/Wallpapers/ --save',
        'picom --xrender-sync-fence --experimental-backends',
        'sleep 1 && gammy',
        'numlockx on',
        'nvidia-settings --load-config-only'
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
        -- Open run menu widget
        run_menu = {
            -- Should it be shown
            visible = false
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
            -- Should tags be numbered
            number = false,
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
        -- Analog clock
        clock = {
            -- Should it be shown
            visible = true,
            -- Format of the time written on the top or left
            primary_format = '%H:%M',
            -- Format of the time written on the bottom or right
            secondary_format = '%a %Y-%m-%d',
        },
        -- Current keyboard layout
        keyboard_layout = {
            -- Should it be shown
            visible = false,
        },
        -- Notifications pane
        notifications_pane = {
            visible = true
        },
        -- System tools
        sys_tools = {
            visible = true,
            cpu_thermal_zone='thermal_zone1'
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
