local system = require('utils.system')

-- All available tty symbols are [here](https://en.wikipedia.org/wiki/Code_page_437)

local M = {}

M.list_chars = {
    tab = '→ ',
    trail = '·',
    nbsp = system.is_gui_choose('␣', '▬'),
    extends = system.is_gui_choose('…', '»'),
    precedes = system.is_gui_choose('…', '«'),
}

M.fill_chars = {
    fold = ' ',
    foldsep = ' ',
    foldopen = system.is_gui_choose('', 'v'),
    foldclose = system.is_gui_choose('', '>'),
    eob = '`',
}

M.border = system.is_gui_choose(
    { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
)

M.diagnostics = {
    error = system.is_gui_choose('', 'E'), --  
    warning = system.is_gui_choose('', 'W'), --  
    hint = system.is_gui_choose('󰛩', 'H'), -- 󰛨 󰛩  
    info = system.is_gui_choose('', 'I'), --  
    ok = system.is_gui_choose('', 'K'), --  
}

M.notify = {
    error = M.diagnostics.error,
    warn = M.diagnostics.warning,
    info = M.diagnostics.info,
    debug = system.is_gui_choose('', 'D'), --  
    trace = system.is_gui_choose('', 'T'), -- 󰙏 
}

M.gitsigns = {
    add = system.is_gui_choose('┃', '│'),
    change = system.is_gui_choose('┃', '│'),
    delete = system.is_gui_choose('', '▶'),
    topdelete = system.is_gui_choose('', '▲'),
    changedelete = system.is_gui_choose('', '▼'),
    untracked = system.is_gui_choose('┋', '║'),
}

M.nvim_tree = {
    folder = {
        default = system.is_gui_choose('', '>'),
        open = system.is_gui_choose('', 'v'),
        empty = system.is_gui_choose('', '>'),
        empty_open = system.is_gui_choose('', 'v'),
        symlink = system.is_gui_choose('󰄾', '→'),
        symlink_open = system.is_gui_choose('󰄼', '↓'),
    },
    git = {
        unstaged = system.is_gui_choose('', '[]'),
        staged = system.is_gui_choose('', '√'),
        unmerged = system.is_gui_choose('', '|τ'),
        renamed = system.is_gui_choose('', '←┘'),
        untracked = system.is_gui_choose('', '+'),
        deleted = system.is_gui_choose('', 'X'),
        ignored = system.is_gui_choose('', '-'),
    },
    modified = system.is_gui_choose('', '∙'),
    bookmark = system.is_gui_choose('󰃀', '♦'),
}

M.completion = {
    Array = '',
    Boolean = '󱎖',
    BreakStatement = '',
    Call = '󰃷',
    CaseStatement = '',
    Class = '',
    Color = '󰸌',
    Constant = '',
    Constructor = '',
    ContinueStatement = '',
    Copilot = '',
    Declaration = '',
    Delete = '',
    DoStatement = '󰕇',
    Enum = '',
    EnumMember = '',
    Event = '⚡',
    Field = '',
    File = '',
    Folder = '',
    ForStatement = '󰕇',
    Function = '',
    Identifier = '󰀫',
    IfStatement = '󰇉',
    Interface = '',
    Key = '',
    Keyword = '',
    List = '',
    Log = '󱖫',
    Lsp = '',
    MarkdownH1 = '󰉫',
    MarkdownH2 = '󰉬',
    MarkdownH3 = '󰉭',
    MarkdownH4 = '󰉮',
    MarkdownH5 = '󰉯',
    MarkdownH6 = '󰉰',
    Method = '',
    Macro = '󰁌',
    Module = '',
    Namespace = '',
    Null = '',
    Number = '',
    Object = '',
    Operator = '',
    Package = '',
    Property = '',
    Reference = '',
    Regex = '',
    Snippet = '󰩫',
    Specifier = '',
    Statement = '',
    SwitchStatement = '󰔡',
    String = '',
    Struct = '',
    Text = '',
    Terminal = '',
    Type = '󰆩',
    TypeParameter = '',
    Unit = '',
    Value = '',
    Variable = '',
    WhileStatement = '󰕇',

    H1Marker = '󰉫',
    H2Marker = '󰉬',
    H3Marker = '󰉭',
    H4Marker = '󰉮',
    H5Marker = '󰉯',
    H6Marker = '󰉰',
    Pair = '',
    Repeat = '󰕇',
    Scope = '',
}

M.buffer_line = {
    diagnostics = M.diagnostics,
    modified = system.is_gui_choose('', '∙'),
    close = system.is_gui_choose('󰖭', 'x'),
}

M.cmd_line = {
    cmdline = system.is_gui_choose(' ', '>_'),
    search_down = system.is_gui_choose(' ', '/↓'),
    search_up = system.is_gui_choose(' ', '/↑'),
    lua = system.is_gui_choose('󰢱 ', 'lua'),
    help = system.is_gui_choose(' ', '[|]'),
    rename = system.is_gui_choose('󰙏 ', '←┘'),
    bash = system.is_gui_choose(' ', '#!'),
    calculator = system.is_gui_choose(' ', '= '),
}

M.lazy = {
    cmd = system.is_gui_choose(M.cmd_line.cmdline, ''),
    config = system.is_gui_choose(M.completion.Declaration, ''),
    event = system.is_gui_choose(M.completion.Event, ''),
    ft = system.is_gui_choose(M.completion.File, ''),
    init = system.is_gui_choose(M.completion.Constructor, ''),
    import = system.is_gui_choose('󰶮 ', ''),
    keys = system.is_gui_choose('󰥻', ''),
    lazy = system.is_gui_choose('󰒲 ', 'Zzz'),
    loaded = system.is_gui_choose('●', '+'),
    not_loaded = system.is_gui_choose('○', '-'),
    plugin = system.is_gui_choose(M.completion.Module, '■'),
    runtime = system.is_gui_choose('', ''),
    source = system.is_gui_choose(M.completion.TypeParameter, ''),
    start = system.is_gui_choose('', '►'),
    task = system.is_gui_choose('', '√'),
    list = '-',
}

M.mason = {
    package_installed = M.lazy.loaded,
    package_pending = M.lazy.task,
    package_uninstalled = M.lazy.not_loaded,
}

M.telescope = {
    prompt = system.is_gui_choose(' ', '>'),
    selection = system.is_gui_choose(' ', '> '),
}

M.indent = {
    char = system.is_gui_choose('│', '│'),
    tab_char = system.is_gui_choose('┆', '║'),
}

M.lsp_signature = system.is_gui_choose(' ', '■')

M.whichkey = {
    breadcrumb = '>',
    separator = system.is_gui_choose('➜', '→'),
    group = system.is_gui_choose(' ', '■ '),
}

M.dropbar = {
    bar = {
        separator = ' ' .. M.whichkey.breadcrumb .. ' ',
        extends = M.list_chars.extends,
    },
    menu = {
        separator = ' ',
        indicator = M.telescope.selection,
    },
}

M.todo = {
    fix = M.notify.debug,
    todo = system.is_gui_choose('', 'T'),
    hack = system.is_gui_choose('', 'P'),
    warning = M.diagnostics.warning,
    performance = system.is_gui_choose('', 'S'),
    note = M.notify.trace,
    test = system.is_gui_choose('', 'U'),
}

M.satellite = {
    moving = system.is_gui_choose({ '⎺', '⎻', '⎼', '⎽' }, { '─' }),
    increasing = system.is_gui_choose({ '-', '=', '≡', '≣' }, { '-', '=', '≡' }),
    search = system.is_gui_choose(
        { '⠁', '⠉', '⠋', '⠛', '⠟', '⠿', '⡿', '⣿' },
        { '-', '=', '≡' }
    ),
    git = {
        add = M.gitsigns.add,
        change = M.gitsigns.change,
        delete = '-',
    },
}

M.status_bar = {
    separator = {
        component = '|',
        section = '',
    },
    mode = {
        ['NORMAL'] = system.is_gui_choose(' ', '') .. 'NORMAL',
        ['O-PENDING'] = system.is_gui_choose(' ', '') .. 'O-PENDING',
        ['INSERT'] = system.is_gui_choose('󰲶 ', '') .. 'INSERT',
        ['VISUAL'] = system.is_gui_choose('󱊔 ', '') .. 'VISUAL',
        ['V-BLOCK'] = system.is_gui_choose('󱊗 ', '') .. 'V-BLOCK',
        ['V-LINE'] = system.is_gui_choose('󱊖 ', '') .. 'V-LINE',
        ['V-REPLACE'] = system.is_gui_choose('󱊙 ', '') .. 'V-REPLACE',
        ['REPLACE'] = system.is_gui_choose('󰷮 ', '') .. 'REPLACE',
        ['COMMAND'] = system.is_gui_choose(' ', '') .. 'COMMAND',
        ['SHELL'] = system.is_gui_choose(' ', '') .. 'SHELL',
        ['TERMINAL'] = system.is_gui_choose(' ', '') .. 'TERMINAL',
        ['EX'] = system.is_gui_choose(' ', '') .. 'EX',
        ['SELECT'] = system.is_gui_choose('󱊔"', '') .. 'SELECT',
        ['S-BLOCK'] = system.is_gui_choose('󱊗"', '') .. 'S-BLOCK',
        ['S-LINE'] = system.is_gui_choose('󱊖"', '') .. 'S-LINE',
        ['CONFIRM'] = system.is_gui_choose(' ', '') .. 'CONFIRM',
        ['MORE'] = system.is_gui_choose(' ', '') .. 'MORE',
    },
    macro = system.is_gui_choose(' ', '@'),
    branch = system.is_gui_choose('', 'git'),
    diagnostics = {
        error = M.diagnostics.error .. ' ',
        warn = M.diagnostics.warning .. ' ',
        info = M.diagnostics.info .. ' ',
        hint = M.diagnostics.hint .. ' ',
    },
    diff = {
        added = system.is_gui_choose('', '+') .. ' ',
        modified = system.is_gui_choose('', '~') .. ' ',
        removed = system.is_gui_choose('', '-') .. ' ',
    },
    file_name = {
        modified = M.nvim_tree.modified,
        readonly = system.is_gui_choose(' ', '-'),
    },
    file_format = {
        unix = system.is_gui_choose('󰌽', 'lf'),
        dos = system.is_gui_choose('󰕰', 'crlf'),
        mac = system.is_gui_choose('', 'cr'),
    },
    space = {
        space = system.is_gui_choose('󱁐', 'sw') .. ' ',
        tab = system.is_gui_choose('', 'ts') .. ' ',
    },
    lsp = {
        done = system.is_gui_choose('', '(√)'),
        animation = system.is_gui_choose({
            '⠋',
            '⠙',
            '⠸',
            '⢰',
            '⣠',
            '⣄',
            '⡆',
            '⠇',
        }, {
            '   ',
            '.  ',
            '.. ',
            '...',
            ' ..',
            '  .',
            '   ',
            '  .',
            ' ..',
            '...',
            '.. ',
            '.  ',
        }),
    },
}

return M
