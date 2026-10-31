local defs = require('defs')
local util = require('util')

local basic = require('plugin.ui.heirline.modules.basic')

local M = {}

--#region Buffer names

---@class ne.plugin.heirline.modules.file.BufferName
---@field prefix string
---@field directory string
---@field basename string

---@param name string
---@return { cwd: string, pid: integer, command: string }?
local function parse_terminal(name)
    local cwd, pid, command = name:match('^term://(.-)//(%d+):(.*)$')
    if not command then
        return nil
    end
    return {
        cwd = cwd,
        pid = tonumber(pid) --[[@as integer]],
        command = vim.fs.basename(command:match('^%S+') or command),
    }
end

---@param result table<integer, ne.plugin.heirline.modules.file.BufferName>
---@param groups table<string, integer[]>
---@param prefix string
local function assign_unique_names(result, groups, prefix)
    for basename, bufs in pairs(groups) do
        if #bufs == 1 then
            result[bufs[1]] = { prefix = prefix, directory = '', basename = basename }
        else
            local directories = vim.tbl_map(function(buf)
                local directory = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.:h')
                return directory == '.' and '' or directory
            end, bufs)

            local labels = util.fs.shorten(directories, defs.icons.ui.ellipsis)
            for i, buf in ipairs(bufs) do
                result[buf] = { prefix = prefix, directory = labels[i], basename = basename }
            end
        end
    end
end

---@type table<integer, ne.plugin.heirline.modules.file.BufferName>?
local buffer_names

---@return table<integer, ne.plugin.heirline.modules.file.BufferName>
local function compute_buffer_names()
    ---@type table<string, integer[]>
    local files = {}
    ---@type table<string, integer[]>
    local help = {}
    ---@type integer[]
    local unnamed = {}
    ---@type integer[]
    local terminals = {}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.bo[buf].buftype
        local listed = vim.bo[buf].buflisted

        if buftype == 'help' and vim.api.nvim_buf_is_loaded(buf) and name ~= '' then
            local basename = vim.fs.basename(name)
            help[basename] = help[basename] or {}
            table.insert(help[basename], buf)
        elseif buftype == 'terminal' and listed then
            table.insert(terminals, buf)
        elseif buftype == '' and listed and name == '' then
            table.insert(unnamed, buf)
        elseif buftype == '' and listed then
            local basename = vim.fs.basename(name)
            files[basename] = files[basename] or {}
            table.insert(files[basename], buf)
        end
    end

    ---@type table<integer, ne.plugin.heirline.modules.file.BufferName>
    local result = {}

    assign_unique_names(result, files, '')
    assign_unique_names(result, help, '[Help]')

    for i, buf in ipairs(unnamed) do
        result[buf] = {
            prefix = '',
            directory = '',
            basename = #unnamed > 1 and ('[No Name] %d'):format(i) or '[No Name]',
        }
    end

    ---@type table<string, { buf: integer, pid: integer }[]>
    local commands = {}
    for _, buf in ipairs(terminals) do
        local terminal = parse_terminal(vim.api.nvim_buf_get_name(buf))
        if terminal then
            commands[terminal.command] = commands[terminal.command] or {}
            table.insert(commands[terminal.command], { buf = buf, pid = terminal.pid })
        end
    end
    for command, entries in pairs(commands) do
        for _, entry in ipairs(entries) do
            result[entry.buf] = {
                prefix = '[Term]',
                directory = '',
                basename = #entries > 1 and (command .. ':' .. entry.pid) or command,
            }
        end
    end

    return result
end

---@param buf integer
---@return ne.plugin.heirline.modules.file.BufferName?
local function buffer_name(buf)
    buffer_names = buffer_names or compute_buffer_names()
    return buffer_names[buf]
end

---@type ne.util.vim.AutocmdEvent[]
M.events = {
    'DirChanged',
    'BufAdd',
    'BufEnter',
    'BufDelete',
    'BufWipeout',
    'BufFilePost',
    'TermOpen',
    { 'OptionSet', pattern = 'buflisted' },
}

local group = vim.api.nvim_create_augroup('ne.heirline.file', { clear = true })

util.vim.autocmd_multiple_events(M.events, {
    group = group,
    callback = function()
        buffer_names = nil
    end,
})

--#endregion

---@param directory string
---@return string
local function with_slash(directory)
    if directory == '' or directory:sub(-1) == '/' then
        return directory
    end
    return directory .. '/'
end

---@param text string
---@return string
local function escape(text)
    local escaped, _ = text:gsub('%%', '%%%%')
    return escaped
end

---@class ne.plugin.heirline.modules.file.Context : ne.plugin.heirline.modules.basic.Component
---@field name string

M.context = basic.context(
    ---@param self ne.plugin.heirline.modules.file.Context
    function(self)
        self.name = vim.api.nvim_buf_get_name(basic.bufnr(self))
    end
)

---@class ne.plugin.heirline.modules.file.NameProps
---@field icon? boolean
---@field name? 'full' | 'shorten' | 'filename' | 'filename_unique' | false
---@field max_directory_length? integer
---@field prefix_hl? string
---@field directory_hl? string
---@field name_hl? string

---@param props? ne.plugin.heirline.modules.file.NameProps
---@return ne.plugin.heirline.modules.basic.Component
function M.name(props)
    props = vim.tbl_extend('force', {
        icon = true,
        name = 'full',
        prefix_hl = 'Comment',
        directory_hl = 'Comment',
    }, props or {})

    ---@class ne.plugin.heirline.modules.file.Name : ne.plugin.heirline.modules.file.Context

    local component = basic.joined(' ',
        --- Icon
        ---@class ne.plugin.heirline.modules.file.Icon : ne.plugin.heirline.modules.file.Name
        ---@field icon string
        ---@field hl_group string
        {
            condition = function()
                return props.icon
            end,
            ---@param self ne.plugin.heirline.modules.file.Icon
            init = function(self)
                local icons = require('mini.icons')
                local buftype = vim.bo[basic.bufnr(self)].buftype
                if buftype == 'help' or buftype == 'terminal' then
                    self.icon, self.hl_group = icons.get('filetype', buftype)
                else
                    self.icon, self.hl_group = icons.get('file', self.name)
                end
            end,
            ---@param self ne.plugin.heirline.modules.file.Icon
            provider = function(self)
                return self.icon
            end,
            ---@param self ne.plugin.heirline.modules.file.Icon
            hl = function(self)
                return self.hl_group
            end,
        },
        --- Name
        ---@class ne.plugin.heirline.modules.file.Path : ne.plugin.heirline.modules.file.Name
        ---@field prefix string
        ---@field directory string
        ---@field basename string
        {
            condition = function()
                return props.name ~= false
            end,
            ---@param self ne.plugin.heirline.modules.file.Path
            init = function(self)
                local buf = basic.bufnr(self)
                local buftype = vim.bo[buf].buftype

                -- Help pages, terminals and unnamed buffers are named the same in every mode
                if buftype == 'help' or buftype == 'terminal' or self.name == '' then
                    local entry = buffer_name(buf)
                    if entry then
                        self.prefix, self.directory, self.basename = entry.prefix, with_slash(entry.directory), entry.basename
                    elseif buftype == 'terminal' then
                        local terminal = parse_terminal(self.name)
                        self.prefix, self.directory, self.basename = '[Term]', '', terminal and terminal.command or self.name
                    elseif buftype == 'help' then
                        self.prefix, self.directory, self.basename = '[Help]', '', vim.fs.basename(self.name)
                    else
                        self.prefix, self.directory, self.basename = '', '', '[No Name]'
                    end
                    return
                end

                local directory, basename
                if props.name == 'filename_unique' then
                    local entry = buffer_name(buf)
                    directory = entry and entry.directory or ''
                    basename = vim.fn.fnamemodify(self.name, ':t')
                else
                    local path = self.name
                    if props.name == 'shorten' then
                        path = vim.fn.pathshorten(vim.fn.fnamemodify(path, ':.'))
                    elseif props.name == 'filename' then
                        path = vim.fn.fnamemodify(path, ':t')
                    else
                        path = vim.fn.fnamemodify(path, ':.')
                    end

                    directory = vim.fs.dirname(path)
                    if directory == '.' then
                        directory = ''
                    end
                    basename = vim.fs.basename(path)
                end

                if directory ~= '' and directory ~= '/' and props.max_directory_length then
                    directory = util.fs.truncate(directory, props.max_directory_length, defs.icons.ui.ellipsis)
                end

                self.prefix = ''
                self.directory = with_slash(directory)
                self.basename = basename
            end,
            basic.joined('',
                --- Prefix
                {
                    ---@param self ne.plugin.heirline.modules.file.Path
                    condition = function(self)
                        return self.prefix ~= ''
                    end,
                    hl = props.prefix_hl,
                    ---@param self ne.plugin.heirline.modules.file.Path
                    provider = function(self)
                        return escape(self.prefix) .. ' '
                    end,
                },
                --- Directory
                {
                    ---@param self ne.plugin.heirline.modules.file.Path
                    condition = function(self)
                        return self.directory ~= ''
                    end,
                    hl = props.directory_hl,
                    ---@param self ne.plugin.heirline.modules.file.Path
                    provider = function(self)
                        return escape(self.directory)
                    end,
                },
                --- Basename
                {
                    hl = props.name_hl,
                    ---@param self ne.plugin.heirline.modules.file.Path
                    provider = function(self)
                        return escape(self.basename)
                    end,
                }
            ),
        }
    )

    return M.context(component)
end

---@class ne.plugin.heirline.modules.file.FlagsProps
---@field modified? boolean
---@field readonly? boolean

---@param props? ne.plugin.heirline.modules.file.FlagsProps
---@return ne.plugin.heirline.modules.basic.Component
function M.flags(props)
    props = vim.tbl_extend('force', {
        modified = true,
        readonly = true,
    }, props or {})

    return basic.joined(' ', {
        --- Modified
        ---@param self ne.plugin.heirline.modules.basic.Component
        condition = function(self)
            return props.modified and vim.bo[basic.bufnr(self)].modified
        end,
        provider = defs.icons.file.modified,
    }, {
        --- Readonly
        ---@param self ne.plugin.heirline.modules.basic.Component
        condition = function(self)
            local bo = vim.bo[basic.bufnr(self)]
            return props.readonly and (not bo.modifiable or bo.readonly)
        end,
        provider = defs.icons.file.readonly,
    })
end

---@class ne.plugin.heirline.modules.file.FiletypeProps
---@field icon? 'ft' | 'static' | false
---@field name? boolean

---@param props? ne.plugin.heirline.modules.file.FiletypeProps
---@return ne.plugin.heirline.modules.basic.Component
function M.filetype(props)
    props = vim.tbl_extend('force', { icon = 'ft', name = true }, props or {})

    ---@param self ne.plugin.heirline.modules.basic.Component
    ---@return boolean
    local function has_filetype(self)
        return vim.bo[basic.bufnr(self)].filetype ~= ''
    end

    ---@class ne.plugin.heirline.modules.file.Filetype : ne.plugin.heirline.modules.basic.Component
    ---@field icon string
    ---@field hl_group? string
    ---@field filetype string

    local component = basic.joined(' ', {
        --- Icon
        ---@param self ne.plugin.heirline.modules.file.Filetype
        condition = function(self)
            if props.icon == 'static' then
                return basic.icon(defs.icons.file.filetype.icon) ~= '' and has_filetype(self)
            end
            return props.icon == 'ft' and has_filetype(self)
        end,
        ---@param self ne.plugin.heirline.modules.file.Filetype
        provider = function(self)
            return self.icon
        end,
        ---@param self ne.plugin.heirline.modules.file.Filetype
        hl = function(self)
            return self.hl_group
        end,
    }, {
        --- Name
        ---@param self ne.plugin.heirline.modules.file.Filetype
        condition = function(self)
            return props.name and has_filetype(self)
        end,
        ---@param self ne.plugin.heirline.modules.file.Filetype
        provider = function(self)
            return self.filetype
        end,
    })

    ---@param self ne.plugin.heirline.modules.file.Filetype
    component.init = function(self)
        self.filetype = vim.bo[basic.bufnr(self)].filetype

        if props.icon == 'ft' then
            local icon, hl_group = require('mini.icons').get('filetype', self.filetype)
            self.icon, self.hl_group = icon, hl_group
        elseif props.icon == 'static' then
            self.icon, self.hl_group = basic.icon(defs.icons.file.filetype.icon), nil
        else
            self.icon, self.hl_group = '', nil
        end
    end

    return component
end

---@class ne.plugin.heirline.modules.file.LineEndingProps
---@field icon? boolean
---@field name? boolean

---@param props? ne.plugin.heirline.modules.file.LineEndingProps
---@return ne.plugin.heirline.modules.basic.Component
function M.line_ending(props)
    props = vim.tbl_extend('force', { icon = true, name = true }, props or {})

    local icons = defs.icons.file.line_ending

    return basic.joined(' ', {
        --- Icon
        ---@param self ne.plugin.heirline.modules.basic.Component
        condition = function(self)
            return props.icon and basic.icon(icons.icon[vim.bo[basic.bufnr(self)].fileformat]) ~= ''
        end,
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            return basic.icon(icons.icon[vim.bo[basic.bufnr(self)].fileformat])
        end,
    }, {
        --- Name
        condition = function()
            return props.name
        end,
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            return icons.name[vim.bo[basic.bufnr(self)].fileformat]
        end,
    })
end

---@class ne.plugin.heirline.modules.file.EncodingProps
---@field icon? boolean
---@field name? boolean

---@param props? ne.plugin.heirline.modules.file.EncodingProps
---@return ne.plugin.heirline.modules.basic.Component
function M.encoding(props)
    props = vim.tbl_extend('force', { icon = true, name = true }, props or {})

    local icon = basic.icon(defs.icons.file.encoding.icon)

    return basic.joined(' ', {
        --- Icon
        condition = function()
            return props.icon and icon ~= ''
        end,
        provider = icon,
    }, {
        --- Name
        condition = function()
            return props.name
        end,
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            local encoding = vim.bo[basic.bufnr(self)].fileencoding
            return encoding ~= '' and encoding or vim.o.encoding
        end,
    })
end

---@class ne.plugin.heirline.modules.file.IndentProps
---@field icon? boolean

---@param props? ne.plugin.heirline.modules.file.IndentProps
---@return ne.plugin.heirline.modules.basic.Component
function M.indent(props)
    props = vim.tbl_extend('force', { icon = true }, props or {})

    local icons = defs.icons.file.indent

    return basic.joined(' ', {
        --- Icon or label
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            if vim.bo[basic.bufnr(self)].expandtab then
                return props.icon and basic.icon(icons.space) or 'spc'
            end
            return props.icon and basic.icon(icons.tab) or 'tab'
        end,
    }, {
        --- Width
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            local bo = vim.bo[basic.bufnr(self)]
            if bo.expandtab then
                -- 'shiftwidth' 0 means "use 'tabstop'"
                return bo.shiftwidth == 0 and bo.tabstop or bo.shiftwidth
            end
            return bo.tabstop
        end,
    })
end

return M
