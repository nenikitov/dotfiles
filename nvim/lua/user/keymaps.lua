local M = {}

---@alias KeymapMode
---| '' Normal, Visual, Select, Operator-pending.
---| 'n' Normal.
---| 'v' Visual and Select.
---| 's' Select.
---| 'x' Visual.
---| 'o' Operator-pending.
---| '!' Insert, Command-line.
---| 'i' Insert.
---| 'l' Insert, Command-line, Lang.
---| 'c' Command-line.
---| 't' Terminal.

--- Default keymap options.
local default_options = {
    noremap = true,
    silent = true,
}

--- Add a keymap.
---@param modes KeymapMode | KeymapMode[] Modes in which keymap will exist.
---@param keys string Key combination.
---@param func string | fun() What to do when keymap is triggered.
---@param description string Description.
---@param options table? Options.
local function map(modes, keys, func, description, options)
    options = vim.tbl_deep_extend('force', default_options, options or {})
    options.desc = description
    vim.keymap.set(modes, keys, func, options)
end

---@alias WhichKeyGroupOpts {description: string, buffer: number?}
---@alias WhichKeyListener fun(mode: string, keys: string, opts: WhichKeyGroupOpts)
---@type WhichKeyListener
local whichkey_listener = nil

--- @type {[KeymapMode]: {[string]: WhichKeyGroupOpts }}
local whichkey_groups = {}

--- Add a keymap group to whichkey
---@param modes KeymapMode | KeymapMode[] Modes in which keymap will exist.
---@param keys string Key combination.
---@param description string Description.
---@param buffer number? Buffer to attach this group to. Defaults to all.
local function whichkey_group(modes, keys, description, buffer)
    if type(modes) == 'string' then
        modes = { modes }
    end

    for _, m in ipairs(modes) do
        whichkey_groups[m] = whichkey_groups[m] or {}
        whichkey_groups[m][keys] = { description = description, buffer = buffer }

        if whichkey_listener then
            whichkey_listener(m, keys, whichkey_groups[m][keys])
        end
    end
end

--- Register a function to add WhichKey prefixes
---@param listener WhichKeyListener
function M.whichkey_register(listener)
    whichkey_listener = listener
    for mode, prefixes in pairs(whichkey_groups) do
        for keys, description in pairs(prefixes) do
            listener(mode, keys, description)
        end
    end
end

function M.general()
    -- Leader
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    map('', '<SPACE>', '<NOP>', 'Leader')

    whichkey_group('n', '<LEADER>b', 'buffer/window/split')

    -- Split
    map('', '<LEADER>bs', '<CMD>split<RETURN>', 'Split horizontally')
    map('', '<LEADER>bv', '<CMD>vsplit<RETURN>', 'Split vertically')

    -- Manipulation
    map('', '<LEADER>bn', '<CMD>enew<RETURN>', 'Create a new empty buffer')
    map('', '<LEADER>br', '<CMD>edit<RETURN>', 'Refresh buffer')
    map('', '<LEADER>bd', '<CMD>bdelete<RETURN>', 'Delete buffer')
    map('', '<LEADER>bD', '<CMD>bdelete!<RETURN>', 'Foce delete buffer')
    map('', '<LEADER>bq', '<CMD>quit<RETURN>', 'Quit window')
    map('', '<LEADER>bQ', '<CMD>quit!<RETURN>', 'Force quit window')
    map('', '<LEADER>bw', '<CMD>write<RETURN>', 'Write buffer')

    -- Go to
    map({ '', 't' }, '<A-h>', '<CMD>wincmd h<RETURN>', 'Go to split on left')
    map({ '', 't' }, '<A-j>', '<CMD>wincmd j<RETURN>', 'Go to split on bottom')
    map({ '', 't' }, '<A-k>', '<CMD>wincmd k<RETURN>', 'Go to split on top')
    map({ '', 't' }, '<A-l>', '<CMD>wincmd l<RETURN>', 'Go to split on right')

    -- Resize
    map({ '', 't' }, '<A-H>', '<CMD>vertical resize -2<RETURN>', 'Decrease width')
    map({ '', 't' }, '<A-J>', '<CMD>resize -1<RETURN>', 'Decrease height')
    map({ '', 't' }, '<A-K>', '<CMD>resize +1<RETURN>', 'Increase height')
    map({ '', 't' }, '<A-L>', '<CMD>vertical resize +2<RETURN>', 'Increase width')

    -- Indent without exiting visual
    map('x', '<', '<gv', 'Unindent without exiting visual')
    map('x', '>', '>gv', 'Indent without exiting visual')

    -- Move lines
    map('x', 'J', ":m '>+1<ENTER>gv=gv", 'Move lines to bottom')
    map('x', 'K', ":m '<-2<ENTER>gv=gv", 'Move lines to top')

    -- Yank in visual without moving
    map('x', 'y', 'ygv<ESC>', 'Yank without moving')

    -- Keep clipboard when pasting in visual mode
    map('x', 'p', '"_dP', 'Paste and keep the clipboard')

    -- Faster navigation
    map('', 'H', '^', 'To first non-blank character of the line')
    map('', 'L', '$', 'To the end of the line')

    -- Search
    map('', '<A-/>', function()
        vim.fn.setreg('/', '')
    end, 'Clear search')
    map('n', 'n', 'nzzzv', 'Go to next search and put cursor in the middle')
    map('n', 'N', 'Nzzzv', 'Go to next search and put cursor in the middle')

    -- Redo
    map('n', 'U', '<C-r>', 'Redo')

    -- Normal mode in terminal
    map('t', '<ESC><ESC>', '<C-\\><C-n>', 'Normal mode')
end

function M.lazy_open()
    whichkey_group('n', '<LEADER>p', 'plugins')

    map('n', '<LEADER>pp', '<CMD>Lazy<CR>', 'Open package manager')
end

function M.telescope_open()
    whichkey_group('n', '<LEADER>t', 'telescope search')

    local builtin = require('telescope.builtin')
    -- local extensions = require('telescope.extensions')

    map('n', '<LEADER>tt', builtin.builtin, 'Builtin pickers')

    map('n', '<LEADER>tf', builtin.find_files, 'Files')
    map('n', '<LEADER>tF', function()
        vim.fn.system('git rev-parse --is-inside-work-tree')
        if vim.v.shell_error == 0 then
            builtin.git_files()
        else
            builtin.find_files()
        end
    end, 'Git files')
    map('n', '<LEADER>tr', builtin.live_grep, 'Regex')

    map('n', '<LEADER>tm', builtin.help_tags, 'Help')
    map('n', '<LEADER>th', builtin.highlights, 'Highlights')
    map('n', '<LEADER>tc', builtin.colorscheme, 'Colorscheme')
    map('n', '<LEADER>tl', builtin.filetypes, 'File type')
end

function M.telescope_navigation()
    local actions = require('telescope.actions')

    return {
        i = {
            ['<C-q>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<RETURN>'] = actions.select_default,
            ['<C-l>'] = actions.select_default,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-y>'] = actions.preview_scrolling_up,
            ['<C-e>'] = actions.preview_scrolling_down,
            ['<TAB>'] = actions.toggle_selection,
            ['<C-w>'] = function()
                vim.api.nvim_input('<ESC>vbdi')
            end,
            ['<C-u>'] = function()
                vim.api.nvim_input('<ESC>v^3ldi')
            end,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        },
        n = {
            ['q'] = actions.close,
            ['<ESC>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['j'] = actions.move_selection_next,
            ['k'] = actions.move_selection_previous,
            ['<RETURN>'] = actions.select_default,
            ['<C-l>'] = actions.select_default,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['gg'] = actions.move_to_top,
            ['G'] = actions.move_to_bottom,
            ['y'] = actions.preview_scrolling_up,
            ['e'] = actions.preview_scrolling_down,
            ['<TAB>'] = actions.toggle_selection,
            ['?'] = actions.which_key,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        },
    }
end

function M.mason_open()
    whichkey_group('n', '<LEADER>p', 'plugins')

    map('n', '<LEADER>pm', '<CMD>Mason<CR>', 'Open LSP install manager')
end

function M.mason_navigation()
    return {
        toggle_package_expand = 'l',
        install_package = 'i',
        update_package = 'u',
        check_package_version = 'c',
        uninstall_package = 'd',
        update_all_packages = 'U',
        check_outdated_packages = 'C',
        cancel_installation = '<C-c>',
        apply_language_filter = 'f',
        toggle_package_install_log = 'l',
        toggle_help = '?',
    }
end

function M.completion()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local mapping = cmp.mapping

    local function map_cmp(callback)
        return mapping(callback, { 'i', 'c' })
    end

    return {
        ['<C-y>'] = map_cmp(mapping.scroll_docs(1)),
        ['<C-e>'] = map_cmp(mapping.scroll_docs(-1)),
        ['<C-j>'] = map_cmp(mapping.select_next_item()),
        ['<C-k>'] = map_cmp(mapping.select_prev_item()),
        ['<C-SPACE>'] = map_cmp(mapping.complete()),
        ['<C-q>'] = map_cmp(mapping.abort()),
        ['<C-l>'] = map_cmp(function(fallback)
            if cmp.visible() then
                cmp.confirm()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end),
        ['<C-h>'] = map_cmp(function(fallback)
            if cmp.visible() then
                cmp.abort()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end),
    }
end

function M.diagnostics()
    whichkey_group('n', '<LEADER>t', 'telescope')
    whichkey_group('n', '<LEADER>e', 'error')

    local telescope = require('telescope.builtin')

    map('n', '<LEADER>te', telescope.diagnostics, 'Show all diagnostics')

    map('n', '<LEADER>eo', vim.diagnostic.open_float, 'Show diagnostic under cursor')
    map('n', '[e', function()
        vim.diagnostic.goto_prev { float = false }
    end, 'To previous diagnostic')
    map('n', ']e', function()
        vim.diagnostic.goto_next { float = false }
    end, 'To next diagnostic')
end

function M.lsp_open()
    whichkey_group('n', '<LEADER>p', 'plugin')

    map('n', '<LEADER>pl', '<CMD>LspInfo<CR>', 'Open LSP info')
    map('n', '<LEADER>pL', '<CMD>LspLog<CR>', 'Open LSP log')
end

function M.lsp(buf)
    whichkey_group('n', '<LEADER>t', 'telescope')
    whichkey_group('n', '<LEADER>s', 'symbol', buf)
    whichkey_group('n', '<LEADER>r', 'refactor', buf)
    whichkey_group('n', '<LEADER>l', 'lsp', buf)

    local telescope = require('telescope.builtin')
    local opts = { buffer = buf }

    map('n', '<LEADER>ts', telescope.lsp_document_symbols, 'Show document symbols', opts)

    map('n', '<LEADER>sr', telescope.lsp_references, 'Show references', opts)
    map('n', '<LEADER>sd', telescope.lsp_definitions, 'Show definitions', opts)
    map('n', '<LEADER>si', telescope.lsp_implementations, 'Show implementations', opts)
    map('n', '<LEADER>so', vim.lsp.buf.hover, 'Show hover', opts)
    map('n', '<LEADER>ss', vim.lsp.buf.signature_help, 'Show signature', opts)

    map({ 'n', 'v' }, '<LEADER>ea', vim.lsp.buf.code_action, 'Automatic fix', opts)
    map('n', '<LEADER>ec', vim.lsp.codelens.run, 'Codelens', opts)

    map('n', '<LEADER>rr', vim.lsp.buf.rename, 'Rename', opts)
    map({ 'n', 'v' }, '<LEADER>rF', function()
        vim.lsp.buf.format { async = true }
    end, 'Format with LSP', opts)

    map('n', '<LEADER>lr', '<CMD>LspRestart<ENTER>', 'Restart', opts)
end

function M.conform()
    whichkey_group({ 'n', 'v' }, '<LEADER>r', 'refactor')

    local conform = require('conform')
    map({ 'n', 'v' }, '<LEADER>rf', function()
        conform.format { async = true, lsp_fallback = true }
    end, 'Format')
end

function M.treesitter()
    whichkey_group('n', '<LEADER>h', 'highlights')

    map('n', '<LEADER>hi', vim.show_pos, 'Show highlight')
    map('n', '<LEADER>hl', vim.treesitter.inspect_tree, 'Show highlight tree')
end

function M.gitsigns(buf)
    whichkey_group({ 'n', 'v' }, '<LEADER>g', 'git')

    local gitsigns = require('gitsigns')
    local opts = { buffer = buf }

    map(
        'n',
        '<LEADER>gd',
        gitsigns.preview_hunk,
        'Preview the differences in the current hunk',
        opts
    )

    map('n', '<LEADER>gb', gitsigns.blame_line, 'Blame current line', opts)

    map('v', '<leader>gr', function()
        gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end, 'Reset selected lines')
    map('n', '<LEADER>gr', gitsigns.reset_hunk, 'Reset current hunk', opts)
    map('n', '<LEADER>gR', gitsigns.reset_buffer, 'Reset current buffer', opts)

    map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end, 'Stage selected lines')
    map('n', '<LEADER>gs', gitsigns.stage_hunk, 'Stage current hunk', opts)
    map('n', '<LEADER>gS', gitsigns.stage_buffer, 'Stage current buffer', opts)

    map('n', '[g', gitsigns.prev_hunk, 'Previous hunk', opts)
    map('n', ']g', gitsigns.next_hunk, 'Next hunk', opts)
end

function M.comment()
    whichkey_group({ 'n', 'o' }, '<LEADER>c', 'comments')

    return {
        toggler = {
            line = '<LEADER>/',
            block = '<LEADER>?',
        },
        opleader = {
            line = '<LEADER>cc',
            block = '<LEADER>cb',
        },
        extra = {
            above = '<LEADER>cO',
            below = '<LEADER>co',
            eol = '<LEADER>cA',
        },
    }
end

function M.toggleterm_open()
    return '<A-CR>'
end

function M.neo_tree_open()
    local neo_tree = require('neo-tree.command')
    map('n', '<LEADER>f', '<CMD>Neotree<ENTER>', 'Show file explorer')
end

function M.neogen()
    whichkey_group('n', '<LEADER>d', 'generate docs')

    local neogen = require('neogen')

    map('n', '<LEADER>dd', neogen.generate, 'Auto')
    map('n', '<LEADER>dt', function()
        neogen.generate { type = 'type' }
    end, 'Type')
    map('n', '<LEADER>df', function()
        neogen.generate { type = 'func' }
    end, 'Function')
    map('n', '<LEADER>de', function()
        neogen.generate { type = 'file' }
    end, 'File')
    map('n', '<LEADER>dc', function()
        neogen.generate { type = 'class' }
    end, 'Class')
end

function M.dropbar_navigation()
    local defaults = require('dropbar.configs').opts.menu.keymaps
    local menu = require('dropbar.utils.menu')

    return {
        l = defaults['<CR>'],
        h = function()
            local m = menu.get_current()
            if not m then
                return
            end
            m:close()
        end,
        ['<ESC>'] = defaults['q'],
        i = function() end,
    }
end

function M.dropbar_open()
    whichkey_group('n', '<LEADER>s', 'symbol')

    map('n', '<LEADER>sb', require('dropbar.api').pick, 'Pick a breadcrumb')
end

return M
