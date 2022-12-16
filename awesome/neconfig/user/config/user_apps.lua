-- ▄▀█ █▀█ █▀█ █▀
-- █▀█ █▀▀ █▀▀ ▄█
local apps = {
    -- Applications that can be opened with shortcuts
    default_apps = {
        terminal = 'alacritty',
        run_menu = 'rofi -show drun'
    },
    -- Commands that will be executed on start up
    startup = {
        -- Force nvidia to reload the config (apply dithering settings)
        'nvidia-settings --load-config-only',
        -- Turn on number pad
        'numlockx on',
        -- Turn on touchpad gestures
        'touchegg',
	-- Network icon in system tray
	'nm-applet',
        -- Launch compositor for transparency and animations
        'picom --xrender-sync-fence',
        -- Set wallpaper
        'nitrogen --restore', --'nitrogen --set-zoom-fill --random ~/Pictures/Wallpapers/ --save',
        -- Adjust blue light level (wait so gammy consistently detects the system tray)
        'sleep 1 && gammy',
    },
    -- Utilities that are used in shortcuts
    utilities = {
        -- Screenshot tool
        screenshot = 'flameshot gui',
        -- Backlight brightness commands
        brightness_get = 'light -G',
        brightness_set = 'light -S %f',
        -- TODO implement these
        -- Volume commands
        volume_get  = '',
        volume_set  = '',
        volume_mute = '',
        -- Media commands,
        media_toggle   = '',
        media_next     = '',
        media_previous = ''
    }
}

return apps
