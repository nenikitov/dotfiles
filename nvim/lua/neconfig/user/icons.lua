local listchars = {
    tab      = '→ ',
    trail    = '·',
    nbsp     = '␣',
    extends  = '▶',
    precedes = '◀'
}

local diagnostics = {
    error   = '',
    warning = '',
    hint    = '',
    info    = ''
}

local gitsigns = {
    add          = '┃',
    change       = '┃',
    delete       = '',
    topdelete    = '',
    changedelete = '',
    untracked    = '┋'
}

local scrollbar_diagnostic = { '-', '=' }
local scrollbar_git = { '┃' }
local scollbar = {
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

local nvim_tree = {
    folder = {
        default      = '',
        open         = '',
        empty        = '',
        empty_open   = '',
        symlink      = '',
        symlink_open = ''
    }
}

local completion = {
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

return {
    completion = completion,
    diagnostics = diagnostics,
    gitsigns = gitsigns,
    listchars = listchars,
    nvim_tree = nvim_tree,
    scollbar = scollbar,
}
