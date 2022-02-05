-- ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄ █ ▄▀█ █     █▀▀ █▀█ █   █▀█ █▀█   █▀█ ▄▀█ █   █▀▀ ▀█▀ ▀█▀ █▀▀
--  █  ██▄ █▀▄ █ ▀ █ █ █ ▀█ █▀█ █▄▄   █▄▄ █▄█ █▄▄ █▄█ █▀▄   █▀▀ █▀█ █▄▄ ██▄  █   █  ██▄
local palette = {
    -- Colors used as background
    bg = {
        normal  = '#080808',
        black   = '#3A3A3A',
        red     = '#B33443',
        green   = '#7F912A',
        yellow  = '#B97845',
        blue    = '#42739F',
        magenta = '#8C5AA2',
        cyan    = '#5AA79D',
        white   = '#B0B0B0'
    },
    -- Colors used as foreground (text, lines, etc)
    fg = {
        normal  = '#CCCCCC',
        black   = '#5A5A5A',
        red     = '#FF7587',
        green   = '#D0E171',
        yellow  = '#F2B286',
        blue    = '#87BDE5',
        magenta = '#D09CE3',
        cyan    = '#9FECE3',
        white   = '#FFFFFF'
    }
}


-- █▀▀ █▀█ █   █▀█ █▀█   █▀ █▀▀ █ █ █▀▀ █▀▄▀█ █▀▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   ▄█ █▄▄ █▀█ ██▄ █ ▀ █ ██▄
local scheme = {
    -- Normal neutral colors
    neutral = {
        bg = palette.bg.normal,
        fg = palette.fg.normal
    },
    -- Highlighted elements on top of neutral background
    surface = {
        bg = palette.bg.black,
        fg = palette.fg.white
    },
    -- Name of the color from the palette used as primary color
    primary   = 'blue',
    -- Name of the color from the palette used as secondary color
    secondary = 'magenta',
    -- Name of the color from the palette used as tertiary color
    tertiary  = 'yellow'
}


-- █▀▀ █▀█ █   █▀█ █▀█   █▀▀ █   ▄▀█ █▀ █▀ █▀▀ █▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   █▄▄ █▄▄ █▀█ ▄█ ▄█ ██▄ ▄█
local classes = {
    --#region Neutral

    -- Normal neutral colors
    neutral = scheme.neutral,
    -- Highlighted elements on top of neutral background
    surface = scheme.surface,
    --#endregion

    --#region Primary

    -- Colors when primary is used for foreground
    primary = {
        bg = scheme.neutral.bg,
        fg = palette.fg[scheme.primary]
    },
    -- Colors when primary is used for background
    primary_surface = {
        bg = palette.bg[scheme.primary],
        fg = scheme.surface.fg
    },
    --#endregion

    --#region Secondary

    -- Colors when secondary is used for foreground
    secondary = {
        bg = scheme.neutral.bg,
        fg = palette.fg[scheme.secondary]
    },
    -- Colors when secondary is used for background
    secondary_surface = {
        bg = palette.bg[scheme.secondary],
        fg = scheme.surface.fg
    },
    --#endregion

    --#region Tertiary

    -- Colors when tertiary is used for foreground
    tertiary = {
        bg = scheme.neutral.bg,
        fg = palette.fg[scheme.tertiary]
    },
    -- Colors when tertiary is used for background
    tertiary_surface = {
        bg = palette.bg[scheme.tertiary],
        fg = scheme.surface.fg
    },
    --#endregion
}

return {
    palette = palette,
    classes = classes
}
