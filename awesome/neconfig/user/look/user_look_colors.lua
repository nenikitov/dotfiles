-- ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄ █ ▄▀█ █     █▀▀ █▀█ █   █▀█ █▀█   █▀█ ▄▀█ █   █▀▀ ▀█▀ ▀█▀ █▀▀
--  █  ██▄ █▀▄ █ ▀ █ █ █ ▀█ █▀█ █▄▄   █▄▄ █▄█ █▄▄ █▄█ █▀▄   █▀▀ █▀█ █▄▄ ██▄  █   █  ██▄
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
    transparency = 0.8,
    fully_transparent = '#00000000'
}


--- Create a color scheme from the name of the color
---@param color string Name of the color from the palette
---@return table colors Corresponding background and foreground colors
local function create_class(color)
    return {
        bg = palette.bg[color],
        fg = palette.fg[color]
    }
end


-- █▀▀ █▀█ █   █▀█ █▀█   █▀ █▀▀ █ █ █▀▀ █▀▄▀█ █▀▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   ▄█ █▄▄ █▀█ ██▄ █ ▀ █ ██▄
local classes = {
    -- Transparency
    transparency = palette.transparency,

    -- Neutral colors
    normal = create_class('normal'),
    surface = {
        bg = palette.bg.black,
        fg = palette.fg.white,
    },

    -- Accent colors
    primary   = create_class('blue'),
    secondary = create_class('magenta'),
    tertiary  = create_class('yellow'),
    error     = create_class('red'),
}


return {
    palette = palette,
    classes = classes,
}
