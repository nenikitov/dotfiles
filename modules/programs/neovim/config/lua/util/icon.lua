-- All available TTY symbols are [here](https://en.wikipedia.org/wiki/Code_page_437)

-- An example of organization could be found [here](https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/icons.lua)

local tty = require('util.tty')

local M = {}

M.key = {
    up               = '↑',
    down             = '↓',
    left             = '←',
    right            = '→',
    ctrl             = tty.gui_choose('󰘴 ', '<C>'),
    alt              = tty.gui_choose('󰘵 ', '<M>'),
    super            = tty.gui_choose('󰝘 ', '<D>'),
    shift            = tty.gui_choose('󰘲 ', '<S>'),
    enter            = tty.gui_choose('󰌑 ', '<ENTER>'),
    escape           = tty.gui_choose('󱊷 ', '<ESC>'),
    mouse_wheel_up   = tty.gui_choose('󱕑 ', '<SCROLLWHEELUP>'),
    mouse_wheel_down = tty.gui_choose('󱕐 ', '<SCROLLWHEELDOWN>'),
    backspace        = tty.gui_choose('󰭜 ', '<BS>'),
    space            = tty.gui_choose('󱁐 ', '<SPACE>'),
    tab              = tty.gui_choose('󰌒 ', '<TAB>'),
    f1               = tty.gui_choose('󱊫 ', 'F1'),
    f2               = tty.gui_choose('󱊬 ', 'F2'),
    f3               = tty.gui_choose('󱊭 ', 'F3'),
    f4               = tty.gui_choose('󱊮 ', 'F4'),
    f5               = tty.gui_choose('󱊯 ', 'F5'),
    f6               = tty.gui_choose('󱊰 ', 'F6'),
    f7               = tty.gui_choose('󱊱 ', 'F7'),
    f8               = tty.gui_choose('󱊲 ', 'F8'),
    f9               = tty.gui_choose('󱊳 ', 'F9'),
    f10              = tty.gui_choose('󱊴 ', 'F10'),
    f11              = tty.gui_choose('󱊵 ', 'F11'),
    f12              = tty.gui_choose('󱊶 ', 'F12'),
}

M.special = {
    tab      = '→ ',
    trailing = '·',
    nbsp     = tty.gui_choose('␣', '▬'),
}

M.border_name = tty.gui_choose('rounded', 'single')
M.border = tty.gui_choose(
    { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
)

M.ui = {
    opened    = tty.gui_choose('', 'v'),
    collapsed = tty.gui_choose('', '>'),

    filled    = tty.gui_choose('●', '■'),
    empty     = tty.gui_choose('○', '-'),

    ellipsis  = tty.gui_choose('⋯', '∙'),

    previous  = tty.gui_choose('', '<'),
    next      = tty.gui_choose('', '>'),

    close     = tty.gui_choose('󰖭', 'x'),

    prompt    = tty.gui_choose('', '>'),
}

M.version_control = {
    commit    = tty.gui_choose(' ', 'commit'),
    branch    = tty.gui_choose(' ', 'branch'),
    staged    = tty.gui_choose(M.ui.filled, '√'),
    added     = tty.gui_choose(' ', '+'),
    deleted   = tty.gui_choose(' ', 'x'),
    ignored   = tty.gui_choose(' ', '-'),
    modified  = tty.gui_choose(M.ui.empty, '.'),
    renamed   = tty.gui_choose(' ', '→'),
    unmerged  = tty.gui_choose(' ', '!'),
    untracked = tty.gui_choose(' ', '?'),
}

M.diff_bar = {
    untracked = tty.gui_choose('┋', ':'),
    added     = tty.gui_choose('┃', '│'),
    changed   = tty.gui_choose('┃', '│'),
    deleted   = tty.gui_choose('', '▶'),
}

M.severity = {
    error   = tty.gui_choose(' ', 'E'),
    warning = tty.gui_choose(' ', 'W'),
    hint    = tty.gui_choose(' ', 'H'),
    info    = tty.gui_choose(' ', 'I'),
    ok      = tty.gui_choose(' ', 'K'),
    debug   = tty.gui_choose(' ', 'D'),
    trace   = tty.gui_choose(' ', 'T'),
}

M.token = {
    array          = tty.gui_choose(' ', 'arr'),
    boolean        = tty.gui_choose('󱎖 ', 'bln'),
    class          = tty.gui_choose(' ', 'cls'),
    color          = tty.gui_choose('󰸌 ', 'col'),
    constant       = tty.gui_choose(' ', 'cst'),
    constructor    = tty.gui_choose(' ', 'ctr'),
    enum           = tty.gui_choose(' ', 'enm'),
    enum_member    = tty.gui_choose(' ', 'enm'),
    event          = tty.gui_choose(' ', 'evt'),
    field          = tty.gui_choose(' ', 'fld'),
    file           = tty.gui_choose(' ', 'fil'),
    folder         = tty.gui_choose(' ', 'dir'),
    ['function']   = tty.gui_choose(' ', 'fnc'),
    interface      = tty.gui_choose(' ', 'ifc'),
    key            = tty.gui_choose(' ', 'key'),
    keyword        = tty.gui_choose(' ', 'kwd'),
    method         = tty.gui_choose(' ', 'mtd'),
    module         = tty.gui_choose(' ', 'mod'),
    namespace      = tty.gui_choose(' ', 'nsp'),
    null           = tty.gui_choose(' ', 'nul'),
    number         = tty.gui_choose(' ', 'num'),
    object         = tty.gui_choose(' ', 'obj'),
    operator       = tty.gui_choose(' ', 'opr'),
    package        = tty.gui_choose(' ', 'pkg'),
    property       = tty.gui_choose(' ', 'ppt'),
    reference      = tty.gui_choose(' ', 'ref'),
    snippet        = tty.gui_choose('󰩫 ', 'snp'),
    string         = tty.gui_choose(' ', 'str'),
    struct         = tty.gui_choose(' ', 'stc'),
    text           = tty.gui_choose(' ', 'txt'),
    type_parameter = tty.gui_choose(' ', 'typ'),
    unit           = tty.gui_choose(' ', 'unt'),
    value          = tty.gui_choose(' ', 'val'),
    variable       = tty.gui_choose(' ', 'var'),
}

M.plugin_state = {
    lazy       = tty.gui_choose('󰒲 ', 'zzz'),

    loaded     = M.ui.filled,
    not_loaded = M.ui.empty,

    cmd        = tty.gui_choose(' ', '[cmd]'),
    config     = tty.gui_choose(M.token.constructor, '[cfg]'),
    debug      = tty.gui_choose(M.severity.debug, '[dbg]'),
    event      = tty.gui_choose(M.token.event, '[' .. M.token.event .. ']'),
    favorite   = tty.gui_choose(' ', '[fav]'),
    ft         = tty.gui_choose(M.token.file, '[ft]'),
    import     = tty.gui_choose(' ', '[imp]'),
    init       = tty.gui_choose(M.token.constructor, '[int]'),
    keys       = tty.gui_choose(' ', '[key]'),
    plugin     = tty.gui_choose(M.token.module, '[plg]'),
    require    = tty.gui_choose('󰢱 ', '[req]'),
    runtime    = tty.gui_choose(' ', '[run]'),
    source     = tty.gui_choose(' ', '[src]'),

    start      = tty.gui_choose('', '►'),
    task       = tty.gui_choose(M.severity.ok, '√'),
}

M.mode = {
    normal           = tty.gui_choose(' ', '') .. 'NORMAL',
    operator_pending = tty.gui_choose(' ', '') .. 'O-PENDING',
    insert           = tty.gui_choose('󰲶 ', '') .. 'INSERT',
    visual           = tty.gui_choose('󱊔 ', '') .. 'VISUAL',
    visual_block     = tty.gui_choose('󱊗 ', '') .. 'V-BLOCK',
    visual_line      = tty.gui_choose('󱊖 ', '') .. 'V-LINE',
    visual_replace   = tty.gui_choose('󱊙 ', '') .. 'V-REPLACE',
    replace          = tty.gui_choose('󰷮 ', '') .. 'REPLACE',
    command          = tty.gui_choose(' ', '') .. 'COMMAND',
    shell            = tty.gui_choose(' ', '') .. 'SHELL',
    terminal         = tty.gui_choose(' ', '') .. 'TERMINAL',
    ex               = tty.gui_choose(' ', '') .. 'EX',
    select           = tty.gui_choose('󱊔"', '') .. 'SELECT',
    select_block     = tty.gui_choose('󱊗"', '') .. 'S-BLOCK',
    select_line      = tty.gui_choose('󱊖"', '') .. 'S-LINE',
    confirm          = tty.gui_choose(' ', '') .. 'CONFIRM',
    more             = tty.gui_choose(' ', '') .. 'MORE',
}

return M
