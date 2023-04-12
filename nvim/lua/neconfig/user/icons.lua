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
    foldopen = '',
    foldclose = ''
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
    rename      = ' ',
}

M.notify = {
    error  = '',
    warn   = '',
    info   = '',
    debug  = '',
    trace  = '󰝶',
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

M.bufferline = {
    buffer_close = '',
    buffer_modified = '●',
    close = '',
    left_trunc = '',
    right_trunc = '',
}

--#endregion



--#region Exports

return M

--#endregion
