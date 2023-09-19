--#region Helpers

--- Module return.
local M = {}

--#endregion



--#region Icons

M.list_chars = {
    tab      = '→ ',
    trail    = '·',
    nbsp     = '␣',
    extends  = '▶',
    precedes = '◀'
}

M.fillchars = {
    fold = ' ',
    foldsep = ' ',
    foldopen = '',
    foldclose = ''
}

M.virtual_text_prefix = '■'
M.diagnostics = {
    error   = '', -- 
    warning = '', -- 
    hint    = '󰛨', -- 
    info    = '', -- 
}

M.telescope = ' '
M.cmdline = {
    cmdline     = ' ',
    search_down = ' ',
    search_up   = ' ',
    filter      = ' ',
    lua         = '󰢱 ',
    help        = ' ',
    rename      = '󰙏 ',
}

M.notify = {
    error  = M.diagnostics.error,
    warn   = M.diagnostics.warning,
    info   = M.diagnostics.info,
    debug  = '',
    trace  = '󰙏',
}


M.gitsigns = {
    add          = '┃',
    change       = '┃',
    delete       = '',
    topdelete    = '',
    changedelete = '',
    untracked    = '┋'
}

M.nvim_tree = {
    folder = {
        default      = '',
        open         = '',
        empty        = '',
        empty_open   = '',
        symlink      = '󰄾',
        symlink_open = '󰄼'
    },
    git = {
        unstaged  = '',
        staged    = '',
        unmerged  = '',
        renamed   = '',
        untracked = '',
        deleted   = '',
        ignored   = '',
    },
    modified = '',
    bookmark = '󰃀'
}

M.completion = {
    Array             = '',
    Boolean           = '󱎖',
    BreakStatement    = '',
    Call              = '󰃷',
    CaseStatement     = '',
    Class             = '',
    Color             = '󰸌',
    Constant          = '',
    Constructor       = '',
    ContinueStatement = '',
    Copilot           = '',
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
    Function          = '',
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
    modified    = '●',
    close       = '󰖭'
}

--#endregion



--#region Exports

return M

--#endregion
