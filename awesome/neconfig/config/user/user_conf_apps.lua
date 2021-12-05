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
        'nvidia-settings --load-config-only',
        'flameshot'
    },
    -- Utilities that are used in shortcuts
    utils = {
        -- Backlight brightness commands
        get_brightness = 'light -G',
        set_brightness = 'light -S %f',
        -- Screenshot tool
        screenshot = 'flameshot gui'
    }
}

return apps
