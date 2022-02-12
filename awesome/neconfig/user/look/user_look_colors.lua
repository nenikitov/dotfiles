-- ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄ █ ▄▀█ █     █▀▀ █▀█ █   █▀█ █▀█   █▀█ ▄▀█ █   █▀▀ ▀█▀ ▀█▀ █▀▀
--  █  ██▄ █▀▄ █ ▀ █ █ █ ▀█ █▀█ █▄▄   █▄▄ █▄█ █▄▄ █▄█ █▀▄   █▀▀ █▀█ █▄▄ ██▄  █   █  ██▄
local palette = {
    -- Colors used for background
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
    -- Colors used for foreground (text, lines, etc)
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
    },
    transparency = 0.8
}


local function create_scheme(color)
    return {
        bg = palette.bg[color],
        fg = palette.fg[color]
    }
end


-- █▀▀ █▀█ █   █▀█ █▀█   █▀ █▀▀ █ █ █▀▀ █▀▄▀█ █▀▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   ▄█ █▄▄ █▀█ ██▄ █ ▀ █ ██▄
local scheme = {
    -- Transparency
    transparency = palette.transparency,

    -- Neutral colors
    neutral = create_scheme('normal'),
    surface = {
        bg = palette.bg.black,
        fg = palette.fg.white,
    },

    -- Accent colors
    primary   = create_scheme('blue'),
    secondary = create_scheme('magenta'),
    tertiary  = create_scheme('yellow'),
    error     = create_scheme('red'),

    -- Titlebar buttons
    close    = create_scheme('red'),
    maximize = create_scheme('green'),
    minimize = create_scheme('yellow'),
    on_top   = create_scheme('blue'),
    floating = create_scheme('magenta'),
    sticky   = create_scheme('cyan'),
}

return {
    palette = palette,
    scheme = scheme
}
