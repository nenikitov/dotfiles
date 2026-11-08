local shared = require('shared')
local util = require('util')

-- HACK: Needed on Ubuntu
local parser_paths = vim.tbl_map(vim.fs.dirname, vim.api.nvim_get_runtime_file('parser', true))

local path = vim.fs.joinpath(util.lazy.plugins_dir, 'lazy.nvim')

if not util.fs.exists(path) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        path
    })
    if vim.v.shell_error ~= 0 then
        vim.notify('Failed to clone lazy.nvim: ' .. out, vim.log.levels.ERROR)
        vim.notify('Press any key to exit...')
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(path)

util.lazy.setup_patches()

-- Event to signal that a file was opened
local Event = require('lazy.core.handler.event')
Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre', 'FileType' } }

require('lazy').setup({
    spec = vim.tbl_map(
        function(dir) return { import = dir } end,
        util.fs.discover_dir('plugin', { ignore_init = true }).dirs
    ),
    root = util.lazy.plugins_dir,
    defaults = { lazy = true },
    change_detection = { notify = false },
    ui = {
        border = vim.o.winborder,
        backdrop = 100,
        title = 'lazy.nvim ' .. shared.icons.plugin.kind.manager,
        icons = {
            cmd = shared.icons.plugin.source.cmd,
            config = shared.icons.plugin.source.config,
            debug = shared.icons.plugin.source.debug,
            event = shared.icons.plugin.source.event,
            favorite = shared.icons.plugin.status.favorite,
            ft = shared.icons.plugin.source.ft,
            init = shared.icons.plugin.source.init,
            import = shared.icons.plugin.source.import,
            keys = shared.icons.plugin.source.keys,
            lazy = shared.icons.plugin.kind.manager,
            loaded = shared.icons.plugin.status.loaded,
            not_loaded = shared.icons.plugin.status.not_loaded,
            plugin = shared.icons.plugin.source.plugin,
            runtime = shared.icons.plugin.source.runtime,
            require = shared.icons.plugin.source.require,
            source = shared.icons.plugin.source.source,
            start = shared.icons.plugin.source.start,
            task = shared.icons.plugin.status.done,
            list = { shared.icons.ui.item }
        },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = { paths = parser_paths },
    },
})

shared.keys.plugin_lazy:bind('n', '<CMD>Lazy<CR>'):set()
shared.keys.plugin:k('r', 'Reload Neovim and the plugins, keeping the session'):bind('n', function()
    local session = vim.fs.joinpath(vim.fn.stdpath('state'), 'reload-session.vim')
    vim.cmd.mksession({ args = { vim.fn.fnameescape(session) }, bang = true })

    -- Help pages of lazy-loaded plugins only resolve once the plugin is on the runtimepath
    local help_plugins = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == 'help' then
            local file = vim.api.nvim_buf_get_name(buf)
            for _, plugin in ipairs(require('lazy').plugins()) do
                if vim.startswith(file, plugin.dir .. '/') then
                    table.insert(help_plugins, plugin.name)
                end
            end
        end
    end

    vim.cmd.restart({
        args = {
            'lua',
            ('require("lazy").load({ plugins = %s }); vim.cmd.source(%q)'):format(
                vim.inspect(help_plugins, { newline = ' ', indent = '' }),
                session
            ),
        },
    })
end):set()
