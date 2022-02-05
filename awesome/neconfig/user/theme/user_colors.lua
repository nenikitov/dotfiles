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
    },
    transparency = 0.8
}


-- █▀▀ █▀█ █   █▀█ █▀█   █▀ █▀▀ █ █ █▀▀ █▀▄▀█ █▀▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   ▄█ █▄▄ █▀█ ██▄ █ ▀ █ ██▄
local scheme = {
    -- Normal neutral colors
    neutral = {
        bg = palette.bg.normal,
        fg = palette.fg.normal,
        transparency = palette.transparency
    },
    -- Highlighted elements on top of neutral background
    surface = {
        bg = palette.bg.black,
        fg = palette.fg.white,
        transparency = 1.0
    },

    -- Name of the color from the palette used as primary color
    primary   = 'blue',
    -- Name of the color from the palette used as secondary color
    secondary = 'magenta',
    -- Name of the color from the palette used as tertiary color
    tertiary  = 'yellow',

    -- Name of the color from the palette used as error color
    error     = 'error'
}


--#region Color class creation utilities (do not modify these)

---Create a color class where the specified color is used as foreground
---@param color_name string Color name in the palette
---@return table class Color class
local function make_class_color(color_name)
    return {
        bg = scheme.neutral.bg,
        fg = palette.fg[color_name],
        transparency = scheme.neutral.transparency
    }
end
---Create a color class where the specified color is used as background
---@param color_name string Color name in the palette
---@return table class Color class
local function make_class_surface(color_name)
    return {
        bg = scheme.bg[scheme[color_name]],
        fg = palette.surface.fg,
        transparency = 1.0
    }
end
---Create a color class where the specified color is used as background and foreground
---@param color_name string Color name in the palette
---@return table class Color class
local function make_class_full(color_name)
    return {
        bg = scheme.bg[color_name],
        fg = scheme.fg[color_name],
        transparency = 1.0
    }
end
--#endregion


-- █▀▀ █▀█ █   █▀█ █▀█   █▀▀ █   ▄▀█ █▀ █▀ █▀▀ █▀
-- █▄▄ █▄█ █▄▄ █▄█ █▀▄   █▄▄ █▄▄ █▀█ ▄█ ▄█ ██▄ ▄█
local classes = {
    -- Neutral
    neutral = scheme.neutral,
    surface = scheme.surface,

    -- Primary
    primary         = make_class_color('primary'),
    primary_surface = make_class_surface('primary'),
    primary_full    = make_class_full('primary'),
    -- Secondary
    secondary         = make_class_color('secondary'),
    secondary_surface = make_class_surface('secondary'),
    secondary_full    = make_class_full('secondary'),
    -- Tertiary
    tertiary         = make_class_color('tertiary'),
    tertiary_surface = make_class_surface('tertiary'),
    tertiary_full    = make_class_full('tertiary'),

    -- Error
    error         = make_class_color('error'),
    error_surface = make_class_surface('error'),
    error_full    = make_class_full('error'),
}

return {
    palette = palette,
    classes = classes
}
