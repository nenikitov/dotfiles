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
    -- "Stand out" elements on top of neutral background
    surface = {
        bg = palette.bg.black,
        fg = palette.fg.white
    },
    -- Name of the color from the palette used as primary "stand out" color
    primary   = 'blue',
    -- Name of the color from the palette used as secondary "stand out" color
    secondary = 'magenta',
    -- Name of the color from the palette used as tertiary "stand out" color
    tertiary  = 'yellow'
}


-- █▀▀ █▀█ █   █▀█ █▀█   █▀▀ █   ▄▀█ █▀ █▀ █▀▀ █▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   █▄▄ █▄▄ █▀█ ▄█ ▄█ ██▄ ▄█
local classes = {
    neutral = scheme.neutral,
    surface = scheme.surface,

    primary = {
        bg = scheme.neutral.bg,
        fg = palette.fg[scheme.primary]
    },
    primary_surface = {
        bg = palette.bg[scheme.primary],
        fg = scheme.surface.fg
    },

    secondary = {
        bg = scheme.neutral.bg,
        fg = palette.fg[scheme.secondary]
    },
    secondary_surface = {
        bg = palette.bg[scheme.secondary],
        fg = scheme.surface.fg
    },

    tertiary = {
        bg = scheme.neutral.bg,
        fg = palette.fg[scheme.tertiary]
    },
    tertiary_surface = {
        bg = palette.bg[scheme.tertiary],
        fg = scheme.surface.fg
    },
}

return {
    palette = palette,
    classes = classes
}
