-- All available TTY symbols are [here](https://en.wikipedia.org/wiki/Code_page_437)

-- An example of organization could be found [here](https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/icons.lua)

local M = {}

---@alias icon.IconKind 'tty' | 'nerd'

---@generic T
---@param tty T
---@param nerd T?
---@return T
function M.icon(tty, nerd)
    if vim.g.icon_charset == "nerd" and nerd then
        return nerd
    else
        return tty
    end
end

M.border_name = M.icon("single", "rounded")

M.ui = {
    opened = M.icon("v", ""),
    closed = M.icon(">", ""),
    filled = M.icon("■", "●"),
    empty = M.icon("-", "○"),
    previous = M.icon("«", "«"),
    next = M.icon("»", "»"),
    close = M.icon("x", "󰖭"),
    prompt = M.icon(">", ""),
}

M.token = {
    array = M.icon("[arr]", " "),
    boolean = M.icon("[bln]", " "),
    class = M.icon("[cls]", " "),
    color = M.icon("[col]", "󰸌 "),
    constant = M.icon("[cst]", " "),
    constructor = M.icon("[ctr]", " "),
    enum = M.icon("[enm]", " "),
    enum_member = M.icon("[enm]", " "),
    event = M.icon("[evt]", " "),
    field = M.icon("[fld]", " "),
    file = M.icon("[fil]", " "),
    folder = M.icon("[dir]", " "),
    ["function"] = M.icon("[fnc]", " "),
    interface = M.icon("[ifc]", " "),
    key = M.icon("[key]", " "),
    keyword = M.icon("[kwd]", " "),
    method = M.icon("[mtd]", " "),
    module = M.icon("[mod]", " "),
    namespace = M.icon("[nsp]", " "),
    null = M.icon("[nul]", " "),
    number = M.icon("[num]", " "),
    object = M.icon("[obj]", " "),
    operator = M.icon("[opr]", " "),
    package = M.icon("[pkg]", " "),
    property = M.icon("[prp]", " "),
    reference = M.icon("[ref]", " "),
    snippet = M.icon("[snp]", "󰩫 "),
    string = M.icon("[str]", " "),
    struct = M.icon("[stc]", " "),
    text = M.icon("[txt]", " "),
    type_parameter = M.icon("[typ]", " "),
    unit = M.icon("[unt]", " "),
    value = M.icon("[val]", " "),
    variable = M.icon("[var]", " "),
}

M.severity = {
    error = M.icon("E", " "),
    warning = M.icon("W", " "),
    hint = M.icon("H", " "),
    info = M.icon("I", " "),
    ok = M.icon("K", " "),
    debug = M.icon("D", " "),
    trace = M.icon("T", " "),
}

M.version_control = {
    commit = M.icon("commit", " "),
    branch = M.icon("branch", " "),
    staged = M.icon("√", M.ui.filled),
    added = M.icon("+", " "),
    deleted = M.icon("-", " "),
    ignored = M.icon("/", " "),
    modified = M.icon(".", M.ui.empty),
    renamed = M.icon("→", " "),
    unmerged = M.icon("!", " "),
    untracked = M.icon("?", " "),
}

M.plugin = {
    cmd = M.icon("[cmd]", " "),
    config = M.icon("[cfg]", M.token.constructor),
    debug = M.icon("[dbg]", M.severity.debug),
    event = M.token.event,
    favorite = M.icon("[fav]", " "),
    ft = M.icon("[ft]", M.token.file),
    init = M.icon("[ini]", M.token["function"]),
    import = M.icon("[imp]", " "),
    keys = M.icon("[key]", " "),
    lazy = M.icon("[lzy]", "󰒲 "),
    loaded = M.ui.filled,
    not_loaded = M.ui.empty,
    plugin = M.icon("[plg]", M.token.package),
    runtime = M.icon("[run]", " "),
    require = M.icon("[req]", "󰢱 "),
    source = M.icon("[src]", " "),
    start = M.icon("►", ""),
    task = M.icon("√", M.severity.ok),
}

return M
