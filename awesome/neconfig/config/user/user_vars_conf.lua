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


local user_vars_conf = {
    apps = apps,
    binds = binds,
    desktop = require('neconfig.config.user.user_desktop'),
    statusbar = require('neconfig.config.user.user_statusbar')
}

return user_vars_conf
