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

M.virtual_text_prefix = '■'
M.diagnostics = {
    error   = '',
    warning = '',
    hint    = '',
    info    = ''
}

M.telescope = ' '
M.cmdline = {
    cmdline     = '>_',
    search_down = ' ',
    search_up   = ' ',
    filter      = '$_',
    lua         = '󰢱 ',
    help        = ' ',
}
M.notify = {
    error  = '',
    warn   = '',
    info   = '',
    debug  = '',
    trace  = '󰝶',
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
    },
    git = {
        unstaged  = '',
        staged    = '',
        unmerged  = '',
        renamed   = '',
        untracked = '',
        deleted   = '󰧧',
        ignored   = '',
    },
    modified = '',
    bookmark = '󰃀'
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
