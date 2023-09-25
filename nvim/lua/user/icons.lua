local tty = require('utils.tty')

local M = {}

M.list_chars = {
    tab      = '→ ',
    trail    = '·',
    nbsp     = tty.choose('␣', '▬'),
    extends  = '▶',
    precedes = '◀'
}

M.fill_chars = {
    fold      = ' ',
    foldsep   = ' ',
    foldopen  = tty.choose('', 'v'),
    foldclose = tty.choose('', '>'),
    eob       = '`'
}

M.border = tty.choose(
    { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
)

M.diagnostics = {
    error   = tty.choose('', 'E'), --  
    warning = tty.choose('', 'W'), --  
    hint    = tty.choose('󰛩', 'H'), -- 󰛨 󰛩  
    info    = tty.choose('', 'I'), --  
}

M.notify = {
    error = M.diagnostics.error,
    warn  = M.diagnostics.warning,
    info  = M.diagnostics.info,
    debug = tty.choose('', 'D'), --  
    trace = tty.choose('', 'T'), -- 󰙏 
}

M.gitsigns = {
    add          = tty.choose('┃', '│'),
    change       = tty.choose('┃', '│'),
    delete       = tty.choose('', '▶'),
    topdelete    = tty.choose('', '▲'),
    changedelete = tty.choose('', '▼'),
    untracked    = tty.choose('┋', '║'),
}

M.nvim_tree = {
    folder = {
        default      = tty.choose('', '>'),
        open         = tty.choose('', 'v'),
        empty        = tty.choose('', '>'),
        empty_open   = tty.choose('', 'v'),
        symlink      = tty.choose('󰄾', '→'),
        symlink_open = tty.choose('󰄼', '↓'),
    },
    git = {
        unstaged  = tty.choose('', '[]'),
        staged    = tty.choose('', '√'),
        unmerged  = tty.choose('', '|τ'),
        renamed   = tty.choose('', '←┘'),
        untracked = tty.choose('', '+'),
        deleted   = tty.choose('', 'X'),
        ignored   = tty.choose('', '-'),
    },
    modified = tty.choose('', '∙'),
    bookmark = tty.choose('󰃀', '♦'),
}

M.completion = {
    Array             = '',
    Boolean           = '󱎖',
    BreakStatement    = '',
    Call              = '󰃷',
    CaseStatement     = '',
    Class             = '',
    Color             = '󰸌',
    Constant          = '',
    Constructor       = '',
    ContinueStatement = '',
    Copilot           = '',
    Declaration       = '',
    Delete            = '',
    DoStatement       = '󰕇',
    Enum              = '',
    EnumMember        = '',
    Event             = '⚡',
    Field             = '',
    File              = '',
    Folder            = '',
    ForStatement      = '󰕇',
    Function          = '',
    Identifier        = '󰀫',
    IfStatement       = '󰇉',
    Interface         = '',
    Key               = '',
    Keyword           = '',
    List              = '',
    Log               = '󱖫',
    Lsp               = '',
    MarkdownH1        = '󰉫',
    MarkdownH2        = '󰉬',
    MarkdownH3        = '󰉭',
    MarkdownH4        = '󰉮',
    MarkdownH5        = '󰉯',
    MarkdownH6        = '󰉰',
    Method            = '',
    Macro             = '󰁌',
    Module            = '',
    Namespace         = '',
    Null              = '',
    Number            = '',
    Object            = '',
    Operator          = '',
    Package           = '',
    Property          = '',
    Reference         = '',
    Regex             = '',
    Snippet           = '󰩫',
    Specifier         = '',
    Statement         = '',
    SwitchStatement   = '󰔡',
    String            = '',
    Struct            = '',
    Text              = '',
    Terminal          = '',
    Type              = '󰆩',
    TypeParameter     = '',
    Unit              = '',
    Value             = '',
    Variable          = '',
    WhileStatement    = '󰕇',
}

M.buffer_line = {
    diagnostics = M.diagnostics,
    modified    = tty.choose('', '∙'),
    close       = tty.choose('󰖭', 'x'),
}

M.cmd_line = {
    cmdline     = tty.choose(' ', '>_'),
    search_down = tty.choose(' ', '/↓'),
    search_up   = tty.choose(' ', '/↑'),
    filter      = tty.choose(' ', '[→'),
    lua         = tty.choose('󰢱 ', 'lua'),
    help        = tty.choose(' ', '[|]'),
    rename      = tty.choose('󰙏 ', '←┘'),
    calculator  = tty.choose(' ', '='),
    bash        = tty.choose(' ', '#!'),
}

M.lazy = {
    cmd        = tty.choose(M.cmd_line.cmdline, ''),
    config     = tty.choose(M.completion.Declaration, ''),
    event      = tty.choose(M.completion.Event, ''),
    ft         = tty.choose(M.completion.File, ''),
    init       = tty.choose(M.completion.Constructor, ''),
    import     = tty.choose('󰶮 ', ''),
    keys       = tty.choose('󰥻', ''),
    lazy       = tty.choose('󰒲 ', 'Zzz'),
    loaded     = tty.choose('●', '+'),
    not_loaded = tty.choose('○', '-'),
    plugin     = tty.choose(M.completion.Module, '■'),
    runtime    = tty.choose('', ''),
    source     = tty.choose(M.completion.TypeParameter, ''),
    start      = tty.choose('', '►'),
    task       = tty.choose('', '√'),
    list       = '-',
}

M.mason = {
    package_installed = M.lazy.loaded,
    package_pending = M.lazy.task,
    package_uninstalled = M.lazy.not_loaded,
}

M.telescope = tty.choose(' ', '>')


return M
