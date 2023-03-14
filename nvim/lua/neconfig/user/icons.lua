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

M.diagnostics = {
    error   = '',
    warning = '',
    hint    = '',
    info    = ''
}

M.git_signs = {
    add          = '┃',
    change       = '┃',
    delete       = '',
    topdelete    = '',
    changedelete = '',
    untracked    = '┋'
}

local scrollbar_diagnostic = { '-', '=' }
local scrollbar_git = { '┃' }
M.scrollbar = {
    cursor     = 'I',
    search     = '/',
    error      = scrollbar_diagnostic,
    warn       = scrollbar_diagnostic,
    info       = scrollbar_diagnostic,
    hint       = scrollbar_diagnostic,
    misc       = scrollbar_diagnostic,
    git_add    = scrollbar_git,
    git_change = scrollbar_git,
    git_delete = scrollbar_git
}

M.nvim_tree = {
    folder = {
        default      = '',
        open         = '',
        empty        = '',
        empty_open   = '',
        symlink      = '',
        symlink_open = ''
    }
}

M.completion = {
    Array         = '',
    Boolean       = '',
    Class         = 'ﴯ',
    Color         = '',
    Constant      = '',
    Constructor   = '',
    Enum          = '',
    EnumMember    = '',
    Event         = '',
    Field         = 'ﰠ',
    File          = '',
    Folder        = '',
    Function      = '',
    Interface     = '',
    Key           = '',
    Keyword       = '',
    Method        = '',
    Module        = '',
    Namespace     = '',
    Null          = '﯇',
    Number        = '',
    Object        = 'ﴯ',
    Operator      = '',
    Package       = '',
    Property      = '炙',
    Reference     = '',
    Snippet       = '',
    String        = '',
    Struct        = 'פּ',
    Text          = '',
    TypeParameter = '',
    Unit          = '',
    Value         = '',
    Variable      = '',
}

--#endregion



--#region Exports

return M

--#endregion
