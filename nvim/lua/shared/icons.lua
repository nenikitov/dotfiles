-- All available TTY symbols are [here](https://en.wikipedia.org/wiki/Code_page_437)
-- All available nerd font symbols are [here](https://www.nerdfonts.com/cheat-sheet)

local shared = require('shared')

---@class ne.shared.icons
local M = {}

---@generic T
---@param gui T
---@param tty T
---@return T
function M.choose(gui, tty)
    if shared.settings.enable_tty_mode then
        return tty
    else
        return gui
    end
end

---@param icon string
---@return string
function M.pad(icon)
    if shared.settings.enable_tty_mode then
        return vim.trim(icon) .. ' '
    end
    return vim.endswith(icon, ' ') and icon or icon .. ' '
end

M.space = {
    char = {
        tab             = '→',
        space_visible   = '·',
        space_invisible = '·',
        nbsp            = M.choose('␣', '▬'),
    },
    indent = {
        space = M.choose('┃', '│'),
        tab   = M.choose('┋', ':'),
    },
}

M.ui = {
    item     = '-',

    opened   = M.choose('󰅀 ', 'v'),
    closed   = M.choose('󰅂 ', '>'),

    filled   = M.choose('●', '■'),
    empty    = M.choose('○', '-'),

    ellipsis = M.choose('…', '∙'),

    previous = '«',
    next     = '»',

    close    = M.choose(' ', 'X'),

    prompt   = '>',
    live     = M.choose(' ', 'l'),

    tree     = {
        vertical = '│ ',
        middle   = '├ ',
        last     = '└ ',
    },

    progress = {
        spinner = M.choose(
            { '⠋', '⠙', '⠸', '⢰', '⣠', '⣄', '⡆', '⠇', },
            { '─', '└', '│', '┌', '─', '┐', '│', '┘', }
        ),
        count = M.choose(
            { '-', '=', '≡', '≣' },
            { '─', '═', '≡' }
        ),
        position = M.choose(
            { '⎺', '⎻', '⎼', '⎽' },
            { '-', '_' }
        ),
    },
}

M.border = M.choose('rounded', 'single')

M.separator = {
    section = {
        left  = '▒',
        right = '▒',
    },
    component = {
        left  = ' │ ',
        right = ' │ ',
    },
    buffer = {
        current = {
            left  = '█',
            right = '',
        },
        visible = {
            left  = '▓',
            right = '',
        },
        inactive = {
            left  = '░',
            right = '',
        },
    },
}

M.key = {
    up               = '↑',
    down             = '↓',
    left             = '←',
    right            = '→',
    control          = M.choose('󰘴 ', 'C-'),
    alt              = M.choose('󰘵 ', 'M-'),
    super            = M.choose('󰝘 ', 'D-'),
    shift            = M.choose('󰘶 ', 'S-'),
    enter            = M.choose('󰌑 ', '<CR>'),
    escape           = M.choose('󱊷 ', '<ESC>'),
    mouse_wheel_up   = M.choose('󱕑 ', '<SCROLLWHEELUP>'),
    mouse_wheel_down = M.choose('󱕐 ', '<SCROLLWHEELDOWN>'),
    backspace        = M.choose('󰭜 ', '<BS>'),
    space            = M.choose('󱁐 ', '<SPACE>'),
    tab              = M.choose('󰌒 ', '<TAB>'),
    f1               = M.choose('󱊫 ', 'F1'),
    f2               = M.choose('󱊬 ', 'F2'),
    f3               = M.choose('󱊭 ', 'F3'),
    f4               = M.choose('󱊮 ', 'F4'),
    f5               = M.choose('󱊯 ', 'F5'),
    f6               = M.choose('󱊰 ', 'F6'),
    f7               = M.choose('󱊱 ', 'F7'),
    f8               = M.choose('󱊲 ', 'F8'),
    f9               = M.choose('󱊳 ', 'F9'),
    f10              = M.choose('󱊴 ', 'F10'),
    f11              = M.choose('󱊵 ', 'F11'),
    f12              = M.choose('󱊶 ', 'F12'),
    nowait           = M.choose(' ', '[nw]'),
}

M.key_names = {
    Up              = M.key.up,
    Down            = M.key.down,
    Left            = M.key.left,
    Right           = M.key.right,
    C               = M.key.control,
    M               = M.key.alt,
    D               = M.key.super,
    S               = M.key.shift,
    CR              = M.key.enter,
    NL              = M.key.enter,
    Esc             = M.key.escape,
    ScrollWheelDown = M.key.mouse_wheel_down,
    ScrollWheelUp   = M.key.mouse_wheel_up,
    BS              = M.key.backspace,
    Space           = M.key.space,
    Tab             = M.key.tab,
    F1              = M.key.f1,
    F2              = M.key.f2,
    F3              = M.key.f3,
    F4              = M.key.f4,
    F5              = M.key.f5,
    F6              = M.key.f6,
    F7              = M.key.f7,
    F8              = M.key.f8,
    F9              = M.key.f9,
    F10             = M.key.f10,
    F11             = M.key.f11,
    F12             = M.key.f12,
}

M.mode = {
    icon = {
        normal           = M.choose(' ', ''),
        operator_pending = M.choose(' ', ''),
        insert           = M.choose('󰲶 ', ''),
        visual           = M.choose('󱊔 ', ''),
        visual_block     = M.choose('󱊗 ', ''),
        visual_line      = M.choose('󱊖 ', ''),
        visual_replace   = M.choose('󱊙 ', ''),
        replace          = M.choose('󰷮 ', ''),
        command          = M.choose(' ', ''),
        shell            = M.choose('󱆃 ', ''),
        terminal         = M.choose(' ', ''),
        ex               = M.choose(' ', ''),
        select           = M.choose('󱊔░', ''),
        select_block     = M.choose('󱊗░', ''),
        select_line      = M.choose('󱊖░', ''),
        confirm          = M.choose(' ', ''),
        more             = M.choose(' ', ''),
    },
    name = {
        normal           = 'NORMAL',
        operator_pending = 'O-PENDING',
        insert           = 'INSERT',
        visual           = 'VISUAL',
        visual_block     = 'V-BLOCK',
        visual_line      = 'V-LINE',
        visual_replace   = 'V-REPLACE',
        replace          = 'REPLACE',
        command          = 'COMMAND',
        shell            = 'SHELL',
        terminal         = 'TERMINAL',
        ex               = 'EX',
        select           = 'SELECT',
        select_block     = 'S-BLOCK',
        select_line      = 'S-LINE',
        confirm          = 'CONFIRM',
        more             = 'MORE',
    },
    recording = M.choose(' ', '@'),
}

M.cmdline = {
    command     = M.choose(M.mode.icon.command, ':'),
    shell       = M.choose(M.mode.icon.shell, '!'),
    search_down = M.choose(' ↓', '/'),
    search_up   = M.choose(' ↑', '?'),
    lua         = M.choose(' ', 'lua'),
    help        = M.choose(' ', 'hlp'),
    expression  = M.choose('󰃬 ', '='),
    input       = M.ui.prompt,
    rename      = M.choose('󰘎 ', 'ren'),
}

M.git = {
    repo = {
        branch     = M.choose(' ', '[brn]'),
        commit     = M.choose(' ', '[cmt]'),
        no_commits = M.choose(' ', '[???]'),
    },
    status = {
        added     = M.choose(' ', 'A'),
        deleted   = M.choose(' ', 'D'),
        ignored   = M.choose(' ', '!'),
        changed   = M.choose(' ', 'M'),
        renamed   = M.choose(' ', 'R'),
        staged    = M.choose(' ', '√'),
        unmerged  = M.choose('󰳤 ', 'U'),
        untracked = M.choose('󱋯 ', '?'),
    },
    sign = {
        untracked = M.choose('┋', ':'),
        added     = M.choose('┃', '│'),
        changed   = M.choose('┃', '│'),
        deleted   = M.choose('▶', '►'),
    },
}

M.file = {
    states = {
        modified = M.git.status.changed,
        readonly = M.choose(' ', 'RO'),
        saved    = M.choose(' ', 'S'),
    },
    line_ending = {
        icon = {
            dos  = M.choose(' ', ''),
            mac  = M.choose(' ', ''),
            unix = M.choose('󰻀 ', ''),
        },
        name = {
            dos  = 'CRLF',
            mac  = 'CR',
            unix = 'LF',
        },
    },
    indent = {
        space = M.choose(M.key.space, M.space.char.space_visible),
        tab   = M.choose(M.key.tab, M.space.char.tab),
    },
    encoding = M.choose('󰾹 ', ''),
    filetype = M.choose(' ', '[ft]'),
}

M.folder = {
    regular      = M.choose('󰉋 ', '>'),
    regular_open = M.choose('󰉖 ', 'v'),
    empty        = M.choose('󰉘 ', '>'),
    empty_open   = M.choose('󰮞 ', 'v'),
    symlink      = M.choose('󰉒 ', '→'),
    symlink_open = M.choose('󱉆 ', '↓'),
}

M.severity = {
    error   = M.choose(' ', 'E'),
    warning = M.choose(' ', 'W'),
    hint    = M.choose(' ', 'H'),
    info    = M.choose(' ', 'I'),
    ok      = M.choose(' ', 'K'),
    debug   = M.choose(' ', 'D'),
    trace   = M.choose(' ', 'T'),
}

M.kind = {
    container = {
        module    = M.choose(' ', 'mod'),
        namespace = M.choose('󰅩 ', 'nsp'),
        package   = M.choose('󰏗 ', 'pkg'),
        file      = M.choose(' ', 'fil'),
        folder    = M.choose(' ', 'dir'),
        section   = M.choose(' ', 'sec'),
        scope     = M.choose(' ', 'scp'),
    },
    type = {
        class          = M.choose(' ', 'cls'),
        struct         = M.choose(' ', 'sct'),
        interface      = M.choose(' ', 'ifc'),
        enum           = M.choose(' ', 'enu'),
        enum_member    = M.choose(' ', 'enm'),
        type_parameter = M.choose(' ', 'typ'),
        definition     = M.choose(' ', 'tdf'),
    },
    callable = {
        ['function'] = M.choose(' ', 'fun'),
        method       = M.choose(' ', 'mtd'),
        constructor  = M.choose(' ', 'ctr'),
        operator     = M.choose(' ', 'opr'),
        macro        = M.choose(' ', 'mac'),
        call         = M.choose(' ', 'cal'),
        delete       = M.choose(' ', 'del'),
    },
    member = {
        field    = M.choose(' ', 'fld'),
        property = M.choose(' ', 'prp'),
        event    = M.choose(' ', 'evt'),
        key      = M.choose(' ', 'key'),
        pair     = M.choose(' ', 'par'),
    },
    data = {
        constant = M.choose(' ', 'cst'),
        variable = M.choose(' ', 'var'),
        value    = M.choose(' ', 'val'),
        number   = M.choose(' ', 'num'),
        string   = M.choose(' ', 'str'),
        boolean  = M.choose(' ', 'bln'),
        null     = M.choose(' ', 'nul'),
        array    = M.choose(' ', 'arr'),
        object   = M.choose(' ', 'obj'),
        color    = M.choose('󰸌 ', 'col'),
        unit     = M.choose(' ', 'unt'),
        list     = M.choose(' ', 'lst'),
        table    = M.choose(' ', 'tbl'),
        regex    = M.choose(' ', 'rgx'),
    },
    name = {
        identifier  = M.choose(' ', 'idn'),
        keyword     = M.choose(' ', 'kwd'),
        reference   = M.choose(' ', 'ref'),
        declaration = M.choose(' ', 'dcl'),
        specifier   = M.choose(' ', 'spc'),
    },
    control = {
        statement  = M.choose(' ', 'stm'),
        ['if']     = M.choose(' ', 'if '),
        switch     = M.choose(' ', 'swt'),
        case       = M.choose(' ', 'cas'),
        ['for']    = M.choose(' ', 'for'),
        ['while']  = M.choose(' ', 'whl'),
        ['do']     = M.choose(' ', 'do '),
        ['repeat'] = M.choose(' ', 'rep'),
        ['break']  = M.choose(' ', 'brk'),
        continue   = M.choose(' ', 'cnt'),
        ['goto']   = M.choose(' ', 'gto'),
        ['return'] = M.choose(' ', 'ret'),
    },
    markup = {
        text     = M.choose(' ', 'txt'),
        snippet  = M.choose('󰩫 ', 'snp'),
        element  = M.choose(' ', 'elm'),
        rule     = M.choose(' ', 'rul'),
        rule_set = M.choose(' ', 'rls'),
        heading  = {
            h1 = M.choose('󰉫 ', 'h1 '),
            h2 = M.choose('󰉬 ', 'h2 '),
            h3 = M.choose('󰉭 ', 'h3 '),
            h4 = M.choose('󰉮 ', 'h4 '),
            h5 = M.choose('󰉯 ', 'h5 '),
            h6 = M.choose('󰉰 ', 'h6 '),
        },
    },
    misc = M.choose('󰠲 ', 'msc'),
}

M.debug = {
    breakpoint  = M.choose('󰏃 ', '■'),
    conditional = M.choose(' ', '♦'),
    rejected    = M.choose('󰏄 ', '○'),
    log_point   = M.choose(' ', 'L'),
    stop        = M.choose(' ', '→'),
}

M.plugin = {
    kind = {
        lsp     = M.choose(' ', '[lsp]'),
        manager = M.choose('󰒲 ', '[plg]'),
        binary  = M.choose('󰏗 ', '[bin]'),
        copilot = M.choose(' ', '[cop]'),
        log     = M.choose(' ', '[log]'),
    },
    status = {
        done       = M.choose(' ', '√'),
        favorite   = M.choose(' ', '[fav]'),
        loaded     = M.ui.filled,
        not_loaded = M.ui.empty,
        working    = M.choose(' ', '↔'),
    },
    lsp = {
        attached    = M.choose(' ', '[lsp]'),
        enabled     = M.choose(' ', '[lsp on]'),
        disabled    = M.choose(' ', '[lsp off]'),
        unavailable = M.choose(' ', '[lsp none]'),
    },
    source = {
        cmd     = M.choose(' ', '[cmd]'),
        config  = M.choose(M.kind.callable.constructor, '[cfg]'),
        debug   = M.choose(M.severity.debug, '[dbg]'),
        event   = M.choose(M.kind.member.event, '[evt]'),
        ft      = M.choose(M.kind.container.file, '[ft]'),
        import  = M.choose(' ', '[imp]'),
        init    = M.choose(M.kind.callable.constructor, '[init]'),
        keys    = M.choose(' ', '[key]'),
        plugin  = M.choose(M.kind.container.module, '[plug]'),
        require = M.choose('󰢱 ', '[req]'),
        runtime = M.choose(' ', '[run]'),
        source  = M.choose(' ', '[src]'),
        start   = M.choose(' ', '[strt]'),
    },
}

M.dashboard = {
    new_file  = M.choose(' ', ''),
    find_file = M.choose(' ', ''),
    find_text = M.choose(' ', ''),
    lazy      = M.choose(M.plugin.kind.manager, ''),
    mason     = M.choose(M.plugin.kind.binary, ''),
    quit      = M.choose(' ', ''),
}

M.logo = {
    glyphs = {
        '███████████████████▄  ',
        '██                  █▄',
        '██  ███▄  ▀██▄  ██  ██',
        '██  ██▀██▄  ▀██▄██  ██',
        '██  ██  ▀██▄  ▀███  ██',
        '▀█                  ██',
        '  ▀███████████████████',
    },
    colors = {
        'bbbbbbbbbbbbbbbbbbbbbb',
        'bb                  gg',
        'bb  wwwwwwwwwwwwww  gg',
        'bb  wwwwwwwwwwwwww  gg',
        'bb  wwwwwwwwwwwwww  gg',
        'bb                  gg',
        'bbgggggggggggggggggggg',
    },
    hls = {
        b = { 'MiniIconsBlue', 'DiagnosticInfo' },
        g = { 'MiniIconsGreen', 'DiagnosticOk' },
        w = { 'MiniIconsGrey', 'Normal' },
    },
}

return M
