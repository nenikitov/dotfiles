-- All available TTY symbols are [here](https://en.wikipedia.org/wiki/Code_page_437)
-- All available nerd font symbols are [here](https://www.nerdfonts.com/cheat-sheet)
-- An example of organization could be found [here](https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/icons.lua)

local defs = require('defs')

---@class ne.defs.icons
local M = {}

---@generic T
---@param gui T
---@param tty T
---@return T
function M.choose(gui, tty)
    if defs.settings.enable_tty_mode then
        return tty
    else
        return gui
    end
end

M.key = {
    up               = '↑',
    down             = '↓',
    left             = '←',
    right            = '→',
    ctrl             = M.choose('󰘴 ', 'C-'),
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
}

M.whitespace = {
    tab             = M.key.right,
    space_visible   = '·',
    space_invisible = '·',
    nbsp            = M.choose('␣', '▬'),
}

M.border = M.choose('rounded', 'single')

M.ui = {
    item     = '-',

    opened   = M.choose('󰅀 ', 'v'),
    closed   = M.choose('󰅂 ', '>'),

    filled   = M.choose('●', '■'),
    empty    = M.choose('○', '-'),

    ellipsis = M.choose('⋯', '∙'),

    previous = '«',
    next     = '»',

    close    = M.choose(' ', 'X'),

    prompt   = '>',
}

M.status = {
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
}

M.version_control = {
    other = {
        commit = M.choose(' ', 'commit'),
        branch = M.choose(' ', 'branch'),
    },
    status = {
        added     = M.choose(' ', 'A'),
        deleted   = M.choose(' ', 'D'),
        ignored   = M.choose(' ', '!'),
        modified  = M.choose(' ', 'M'),
        renamed   = M.choose(' ', 'R'),
        staged    = M.choose(' ', '√'),
        unmerged  = M.choose('󰳤 ', 'U'),
        untracked = M.choose('󱋯 ', '?'),
    },
}

M.file = {
    modified = M.version_control.status.modified,
    readonly = M.choose(' ', 'RO'),
    line_endings = {
        dos  = M.choose(' ', 'crlf'),
        mac  = M.choose(' ', 'cr'),
        unix = M.choose('󰻀 ', 'lf'),
    },
}

M.folder = {
    regular      = M.choose('󰉋 ', '>'),
    regular_open = M.choose('󰉖 ', 'v'),
    empty        = M.choose('󰉘 ', '>'),
    empty_open   = M.choose('󰮞 ', 'v'),
    symlink      = M.choose('󰉒 ', '→'),
    symlink_open = M.choose('󱉆 ', '↓'),
}

M.diff_bar = {
    untracked = M.choose('┋', ':'),
    added     = M.choose('┃', '│'),
    changed   = M.choose('┃', '│'),
    deleted   = M.choose('󰍟', '►'),
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

M.debug = {
    breakpoint  = M.choose('󰏃 ', '■'),
    conditional = M.choose(' ', '♦'),
    rejected    = M.choose('󰏄 ', '○'),
    log_point   = M.choose(' ', 'L'),
    stop        = M.choose(' ', '→'),
}

M.token = {
    array          = M.choose(' ', 'arr'),
    boolean        = M.choose(' ', 'bln'),
    class          = M.choose(' ', 'cls'),
    color          = M.choose('󰸌 ', 'col'),
    constant       = M.choose(' ', 'cst'),
    constructor    = M.choose(' ', 'ctr'),
    enum           = M.choose(' ', 'enu'),
    enum_member    = M.choose(' ', 'enm'),
    event          = M.choose(' ', 'evt'),
    field          = M.choose(' ', 'fld'),
    file           = M.choose(' ', 'fil'),
    folder         = M.choose(' ', 'dir'),
    ['function']   = M.choose(' ', 'fun'),
    interface      = M.choose(' ', 'ifc'),
    key            = M.choose(' ', 'key'),
    keyword        = M.choose(' ', 'kwd'),
    method         = M.choose(' ', 'mtd'),
    misc           = M.choose('󰠲 ', 'msc'),
    module         = M.choose(' ', 'mod'),
    namespace      = M.choose('󰅩 ', 'nsp'),
    null           = M.choose(' ', 'nul'),
    number         = M.choose(' ', 'num'),
    object         = M.choose(' ', 'obj'),
    operator       = M.choose(' ', 'opr'),
    package        = M.choose('󰏗 ', 'pkg'),
    property       = M.choose(' ', 'prp'),
    reference      = M.choose(' ', 'ref'),
    snippet        = M.choose('󰩫 ', 'snp'),
    string         = M.choose(' ', 'str'),
    struct         = M.choose(' ', 'sct'),
    text           = M.choose(' ', 'txt'),
    type_parameter = M.choose(' ', 'typ'),
    unit           = M.choose(' ', 'unt'),
    value          = M.choose(' ', 'val'),
    variable       = M.choose(' ', 'var'),
}

M.plugin = {
    manager = M.choose('󰒲 ', 'Zzz'),
    status = {
        done       = M.choose(' ', '√'),
        favorite   = M.choose(' ', '[fav]'),
        loaded     = M.ui.filled,
        not_loaded = M.ui.empty,
        working    = M.choose(' ', '↔'),
    },
    source = {
        cmd     = M.choose(' ', '[cmd]'),
        config  = M.choose(M.token.constructor, '[cfg]'),
        debug   = M.choose(M.severity.debug, '[dbg]'),
        event   = M.choose(M.token.event, '[evt]'),
        ft      = M.choose(M.token.file, '[ft]'),
        import  = M.choose(' ', '[imp]'),
        init    = M.choose(M.token.constructor, '[init]'),
        keys    = M.choose(' ', '[key]'),
        plugin  = M.choose(M.token.module, '[plug]'),
        require = M.choose('󰢱 ', '[req]'),
        runtime = M.choose(' ', '[run]'),
        source  = M.choose(' ', '[src]'),
        start   = M.choose(' ', '[strt]'),
    },
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
}

return M
